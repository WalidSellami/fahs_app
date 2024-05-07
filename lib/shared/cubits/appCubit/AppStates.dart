abstract class AppStates {}

class InitialAppState extends AppStates {}

// Upload Document

class LoadingUploadDocumentAppState extends AppStates {}

class UpdateLoadingProgressExtractFileAppState extends AppStates {}

class SuccessUploadDocumentAppState extends AppStates {}

class ErrorUploadDocumentAppState extends AppStates {

  dynamic error;
  ErrorUploadDocumentAppState(this.error);

}


// Get Report

class UpdateLoadingProgressAppState extends AppStates {}

class LoadingGetReportAppState extends AppStates {}

class UpdateNbrSourcesAppState extends AppStates {}

class SuccessGetReportAppState extends AppStates {}

class ErrorGetReportAppState extends AppStates {

  dynamic error;
  ErrorGetReportAppState(this.error);

}

class ClearDataReportAppState extends AppStates {}
