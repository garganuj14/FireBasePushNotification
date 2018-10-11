
import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var imgNotification: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.imgCircle.layer.cornerRadius = self.imgCircle.frame.size.height/2
       // self.imgCircle.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
