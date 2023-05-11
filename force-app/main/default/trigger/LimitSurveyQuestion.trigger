.

trigger LimitQuestionsPerSurvey on Survey_Question__c (before insert, before update) {
    List<Id> surveyIds = new List<Id>();
    for (Survey_Question__c q : Trigger.new) {
        // Collect unique survey ids
        if (surveyIds.contains(q.Survey__c)) {
            // Skip if survey is already in the list
            continue;
        }
        surveyIds.add(q.Survey__c);
    }
 
    // Count questions per survey
    Map<Id, Integer> questionCount = new Map<Id, Integer>();
    for (AggregateResult ar : [SELECT Survey__c survey, count(Id) questionCount FROM Survey_Question__c WHERE Survey__c IN :surveyIds GROUP BY Survey__c]) {
        questionCount.put(Id.valueOf(ar.get('survey')), Integer.valueOf(ar.get('questionCount')));
    }
 
    // Check if the current trigger has more than 20 questions
    for (Survey_Question__c q : Trigger.new) {
        if (questionCount.get(q.Survey__c) + 1 > 20) {
            q.addError('Only 20 questions are allowed per survey.');
        }
    }
}