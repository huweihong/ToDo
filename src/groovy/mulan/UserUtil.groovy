package mulan

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

class UserUtil {
	static UserService userService = UserServiceFactory.getUserService();
	static User getMe(){
		
		return userService.getCurrentUser();
		
	}
	static String getLogoutUrl(String actionstring){
		return userService.createLogoutURL(actionstring)
	}
	static String getLogInUrl(String actionstring){
		return userService.createLoginURL(actionstring)
	}
}
