

import Foundation

class RelazioneRepository: BaseRepository {
	
	func insertRel(by relazione: Relazione) {
		let query = "INSERT INTO Relazione(codice, desRelM, desRelF) VALUES(:codice, :desRelM, :desRelF)"
		db.beginTransaction()
		let dictionary: [String:Any] = [ "codice" : relazione.codice,
										 "desRelM" : relazione.desRelM,
										 "desRelF" : relazione.desRelF ]
		self.db.executeUpdate(query, withParameterDictionary: dictionary)
        //print("INSERT RELAZIONE: ", relazione.codice)
		db.commit()
	}
	
	func getAll() -> [Relazione] {
		var array = [Relazione]()
		let query = "SELECT * FROM Relazione"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				let rel = Relazione()
				rel.codice = Int(result.int(forColumn: "codice"))
				rel.desRelM = result.string(forColumn: "desRelM")
				rel.desRelF = result.string(forColumn: "desRelF")
				array.append(rel)
			}
		} catch {
			print(error)
		}
		return array
	}
	
	func getCod(string: String) -> Int {
		let query = "SELECT codice FROM Relazione WHERE desRelM = \(string) OR desRelF = \(string)"
		var cod = Int()
		do {
			let result = try self.db.executeQuery(query, values: nil)
			cod = Int(result.int(forColumn: "codice"))
		} catch {
			print(error)
		}
		return cod
	}
	
	func getRel(by cod: Int, isMan: Bool) -> String {
		let relM = "desRelM"
		let relF = "desRelF"
		var string = ""
		let query = "SELECT * FROM Relazione WHERE codice = \(cod)"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				string = result.string(forColumn: "\(isMan ? relM : relF)") ?? ""
			}
		} catch {
			print(error)
		}
		return string
	}
	
	func deleteAll() {
		do{
			db.beginTransaction()
			let query = "DELETE FROM Relazione"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()

	}
}
