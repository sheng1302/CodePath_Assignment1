//
//  ViewController.swift
//  Flix
//
//  Created by Sheng Liu on 2/18/19.
//  Copyright © 2019 Sheng Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var movies = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                
                // TODO: Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                
                // TODO: Reload your table view data
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //If another cell is off screen, give me recycle cell. Otherwise create a new one...
        
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synosis = movie["overview"] as! String
        let base_url = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: base_url + posterPath)
        
        
        cell.title.text = title
        cell.synosisLabel.text = synosis
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get the new view controller using seque.destination.
        // pass the selected object to the new view controller.
        
        // we need to get a reference to our destination view controller
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let detailsViewController = segue.destination as! PhotoDetailsViewController
        
        let movie = movies[indexPath.row]
        
        detailsViewController.movie = movie
    }


}

