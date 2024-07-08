public class UpdateOpportunityStageBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query Opportunities that are not closed and has close date in the next 30 days
        return Database.getQueryLocator([
            SELECT Id, StageName, CloseDate
            FROM Opportunity
            WHERE IsClosed = false AND CloseDate <= :Date.today().addDays(30) AND StageName != 'Closing'
        ]);
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for (Opportunity opp : scope) {
            // Update the Opportunity stage to 'Closing'
            opp.StageName = 'Closing';
            opportunitiesToUpdate.add(opp);
        }

        // Update the Opportunities in bulk
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {
    }
}