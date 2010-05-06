package mulan
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.users.User;
import javax.persistence.*;

@Entity
class Task implements Serializable {

    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Key id
	String status
	String goal
	User author
	List<Long> cats=[]
	@Temporal(TemporalType.DATE)
    Date        beginDate   = new Date()
    @Temporal(TemporalType.DATE)
    Date        endDate 

    static constraints = {
    	id  visible:false
    	status(blank:false, maxSize:10, inList:['Cancel', 'Open','End'])
    	goal(bland:false,maxSize:200)
    	beginDate(blank:false)
    	author(blank:false)
	}
    String toString(){
    	if(goal.length()>20)
    	return goal.substring(0, 20)+"......"
    	else
    	return goal
    }
	
}
