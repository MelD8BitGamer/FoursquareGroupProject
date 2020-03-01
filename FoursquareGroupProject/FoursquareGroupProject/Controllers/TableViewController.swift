import UIKit
import DataPersistence
final class TableViewController: UIViewController {
    
    private var dataPersistence: DataPersistence<Collection>
    
    init(_ dataPersistence: DataPersistence<Collection>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let venueTableView = tableViewView()
    
//    public var allImages = [UIImage]() {
//        
//    }
    
    public var venues = [Venue]() {
        didSet {
            venueTableView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = venueTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        venueTableView.tableView.delegate = self
        venueTableView.tableView.dataSource = self
    }
    
}
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedCell = venues[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as? VenueTableViewCell {
            //cell.venueImageView.image = allImages[indexPath.row]
            cell.configureCell(venue: selectedCell)
//                        let aImage = allImages[indexPath.row]
//                        cell.imageView?.image = aImage
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = venues[indexPath.row]
        let detailVC = DetailViewController(dataPersistence, venue: selectedCell)
        present(detailVC, animated: true, completion: nil)
    }
}



