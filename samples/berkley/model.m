
BerkeleyDb : [FLogging] FPersistency [FStatistics] [featureMemoryBudget] FConcurrency* FDbOperation* FBtree BASE :: BerkeleyDB ;

FLogging : [featureLoggingFile] [featureLoggingConsole] [featureLoggingDbLog] [featureLoggingFinest] [featureLoggingFiner] [featureLoggingFine] [featureLoggingInfo] [featureLoggingConfig] [featureLoggingSevere] featureLoggingBase :: Logging ;

FPersistency : FPersistencyFeatures* FIOFeature :: Persistency ;

FPersistencyFeatures | featureChecksum
	| featureFileHandleCache
	| featureHandleFullDiscError
	| featureEnvironmentLock
	| Checkpointer
	| Cleaner ;
	
Checkpointer : [featureCustomizableCheckpointerTime] [featureCustomizableCheckpointerBytes] [featureCheckpointerDaemon] :: _Checkpointer ;

Cleaner : [featureLookAheadCache] [featureCleanerDaemon] :: _Cleaner ;

FIOFeature | NIO
	|  IO ;
	
NIO : [featureDirectNIO] FNIOType :: _NIO ;
IO : [featureSynchronizedIO] featureIO :: _IO ;

FNIOType | featureNIO
	| featureChunkedNIO ;

FStatistics : FStatisticsFeatures+ featureStatisticsBase :: Statistics ;

FStatisticsFeatures | EnvStats
	| featureStatisticsDatabase
	| featureStatisticsLock
	| featureStatisticsPreload
	| featureStatisticsSequence
	| featureStatisticsTransaction ;
	
EnvStats : [featureStatisticsEnvLog] [featureStatisticsEnvINCompressor] [featureStatisticsEnvFSync] [featureStatisticsEnvEvictor] [featureStatisticsEnvCleaner] [featureStatisticsEnvCheckpointer] [featureStatisticsEnvCaching] featureStatisticsEnvBase :: _EnvStats ;	

FConcurrency | featureLatch
	| featureFSync
	| featureTransaction
	| dummyFeatureLocking
	| featureCheckLeaks ;

FDbOperation | featureDeleteDb
	| featureTruncateDb ;

FBtree : [featureVerifier] [featureTreeVisitor] [featureINCompressor] [FEvictor] :: BTree ;

FEvictor : [featureCriticalEviction] [featureEvictorDaemon] featureEvictor :: Evictor ;




