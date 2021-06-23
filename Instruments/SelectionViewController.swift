//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var thumbs = [UIImage]() // this is the array to strore the generted thumbnails
	var dirty = false

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default

		if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
			for item in tempItems {
				if item.range(of: "Large") != nil {
					items.append(item)
				}
			}
		}

		for item in items {
			if let name = item.components(separatedBy: "-").first {
				if let image = loadThumbnail(name: name) {
					thumbs.append(image)
				} else {
					let thumb = makeThumb(currentImage: item)
					save(thumb, name: name)
					thumbs.append(thumb)
				}
			}
		}

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

	func makeThumb(currentImage: String) -> UIImage {
		let imageName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
		guard let path = Bundle.main.path(forResource: imageName, ofType: nil),
					let original = UIImage(contentsOfFile: path) else {
			fatalError("Fatal Error: Unable to load image '\(imageName)'")
		}

		let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
		let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		let thumb = renderer.image { ctx in
			ctx.cgContext.addEllipse(in: renderRect)
			ctx.cgContext.clip()

			original.draw(in: renderRect)
		}
		return thumb
	}

	func save(_ image: UIImage, name: String) {
		let imagePath = getDocumentsDirectory().appendingPathComponent(name).appendingPathExtension("png")
		if let imageData = image.pngData() {
			try? imageData.write(to: imagePath)
		}
	}

	func loadThumbnail(name: String) -> UIImage? {
		let imagePath = getDocumentsDirectory().appendingPathComponent(name).appendingPathExtension("png")
		return UIImage(contentsOfFile: imagePath.path)
	}

	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// Return the number of sections.
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return items.count * 10
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row % items.count]
		let thumb = thumbs[indexPath.row % thumbs.count]
		let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
		cell.imageView?.image = thumb

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
		cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
		navigationController!.pushViewController(vc, animated: true)
	}
}
