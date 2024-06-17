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

class ConfirmDetectRatioAppState extends AppStates {}

class UpdateLoadingProgressAppState extends AppStates {}

class LoadingGetReportAppState extends AppStates {}

class UpdateNbrSourcesAppState extends AppStates {}

class ChangeDropDownChosenValueAppState extends AppStates {}

class ChangeDropDownValueAppState extends AppStates {}

class GenerateItemsDropDownAppState extends AppStates {}

class SuccessGetReportAppState extends AppStates {}

class ErrorGetReportAppState extends AppStates {

  dynamic error;
  ErrorGetReportAppState(this.error);

}

class ClearDataReportAppState extends AppStates {}

class ClearChosenDataAppState extends AppStates {}
