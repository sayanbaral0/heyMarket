public class LeadTriggerService {
    public static Boolean isValidEmail(String email) {
        if (String.isBlank(email)) {
            return false;
        }
        Pattern emailPattern = Pattern.compile('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$');
        Matcher emailMatcher = emailPattern.matcher(email);
        return emailMatcher.matches();
    }
    
    
    public static Boolean isValidPhone(String phone) {
        
        Pattern pattern = Pattern.compile('^\\d{10}$|^\\+\\d{12}$');
        Matcher matcher = pattern.matcher(phone);
        return matcher.matches();
    }
}