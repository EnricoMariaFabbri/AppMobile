

import UIKit

class FileHelper: NSObject {
    static let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
	static func storeFileLocally(_ filePath: String, fileName:String, data: Data?) {
		// create your document folder url
		//let documentsUrl =  documentFolderPath()
		
		// your destination file url
		//let destinationUrl = documentsUrl.appendingPathComponent(filePath)
        let destinationUrl = documentPath.appendingPathComponent(filePath)
		
		do {
			try FileManager.default.createDirectory(atPath: destinationUrl.path, withIntermediateDirectories: true, attributes: nil)
			if let data = data {
				if (try? data.write(to: destinationUrl.appendingPathComponent(fileName), options: [.atomic])) != nil {
					try (destinationUrl.appendingPathComponent(fileName) as NSURL).setResourceValue(true, forKey:URLResourceKey.isExcludedFromBackupKey)
					print("file saved at \(destinationUrl)")
				}
				else {
					print("error saving file")
				}
			}
		} catch {
			//print(error.localizedDescription);
		}
	}
	
	static func getFileLocalPathByUrl(_ path: String) -> URL? {
		// create your document folder url
		let documentsUrl =  documentFolderPath()
		
		//let destinationUrl = documentsUrl.appendingPathComponent(path)
        let destinationUrl = documentPath.appendingPathComponent(path)
		
		if FileManager().fileExists(atPath: destinationUrl.path) {
			return destinationUrl
		}
//		else {
//			print("fileName is nil")
//		}
		
		return nil
	}

	static func documentFolderPath() -> URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
	}
	
	static func fileExtension(_ fileName:String) -> String {
		let indice = fileName.range(of: ".", options: .backwards)?.upperBound
		if indice != nil {
			return fileName.substring(from: indice!)
		} else {
			return ""
		}
	}
}
