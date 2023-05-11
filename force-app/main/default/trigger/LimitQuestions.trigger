.

trigger SurveyQuestionTrigger on Survey_Question__c (before insert, before update) {
  Map<Id, Integer> surveyRecordCountMap = new Map<Id, Integer>();
  for (Survey_Question__c sq : Trigger.new) {
    if (surveyRecordCountMap.containsKey(sq.Survey__c)) {
      surveyRecordCountMap.put(sq.Survey__c, surveyRecordCountMap.get(sq.Survey__c) + 1);
    } else {
      surveyRecordCountMap.put(sq.Survey__c, 1);
    }
  }
  for (Survey_Question__c sq : Trigger.new) {
    if (surveyRecordCountMap.get(sq.Survey__c) > 20) {
      sq.addError('Cannot add more than 20 questions for one survey');
    }
  }
}