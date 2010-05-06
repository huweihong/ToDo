package mulan
import javax.persistence.*;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.users.User;


@Entity
class Category implements Serializable {

    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Key id
	String name
	User author
	List<Long> tasks=[]
    static constraints = {
    	id visible:false
    	name(blank:false,maxSize:20,unique: true)
    	author(blank:false)
	}  
    String toString(){
		return name
	}       
}
