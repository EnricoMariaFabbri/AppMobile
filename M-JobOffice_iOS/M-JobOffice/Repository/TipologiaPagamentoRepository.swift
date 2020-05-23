

import UIKit

class TipologiaPagamentoRepository: BaseRepository {

    func insertTipoPagamento(byTipoPagamento tipoPagamento : TipoPagamento){
        
        db.beginTransaction()
        
        let query = "INSERT INTO Tipo_Pagamento (id,nome,codice,icona) values (:id,:nome,:codice,:icon)"

        let dict : [String:Any] = ["id":tipoPagamento.id ?? NSNull(),
                    "nome":tipoPagamento.nome ?? NSNull(),
                    "codice": tipoPagamento.codice ?? NSNull(),
                    "icon": tipoPagamento.icon ?? NSNull()]

        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
        
    }
    
    func deleteAll(){
        do{
            db.beginTransaction()
            let query = "DELETE FROM Tipo_Pagamento"
            try self.db.executeUpdate(query, values: nil)
        }
        catch{
            print(error)
        }
        db.commit()
    }
    
    func getAllTipiPagamento() -> [TipoPagamento]{
        
       var tipiPagamento = [TipoPagamento]()
        let query  = "SELECT * FROM Tipo_Pagamento"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                let tipoPagamento = TipoPagamento()
                tipoPagamento.id = Int(result.int(forColumn: "id"))
                tipoPagamento.nome = result.string(forColumn: "nome")
                tipoPagamento.codice = result.string(forColumn: "codice")
                tipoPagamento.icon = Int(result.int(forColumn: "icona"))
                
                tipiPagamento.append(tipoPagamento)
            }
        } catch {
            print(error)
        }
        return tipiPagamento
    }
    
    func getCodiceTipoPagamento(byNome nome: String) -> TipoPagamento?{
        
        var tipoPagamento : TipoPagamento?
        let query  = "SELECT * FROM Tipo_Pagamento WHERE nome='\(nome)'"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                tipoPagamento = TipoPagamento()
                tipoPagamento?.id = Int(result.int(forColumn: "id"))
                tipoPagamento?.nome = result.string(forColumn: "nome")
                tipoPagamento?.codice = result.string(forColumn: "codice")
                tipoPagamento?.icon = Int(result.int(forColumn: "icona"))
            }
        } catch {
            print(error)
        }
        return tipoPagamento
    }
    
    func getNameTipoPagamento(byCode code: String) -> TipoPagamento?{
        
        var tipoPagamento : TipoPagamento?
        let query  = "SELECT * FROM Tipo_Pagamento WHERE codice='\(code)'"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                tipoPagamento = TipoPagamento()
                tipoPagamento?.id = Int(result.int(forColumn: "id"))
                tipoPagamento?.nome = result.string(forColumn: "nome")
                tipoPagamento?.codice = result.string(forColumn: "codice")
                tipoPagamento?.icon = Int(result.int(forColumn: "icona"))
            }
        } catch {
            print(error)
        }
        return tipoPagamento
    }
}
