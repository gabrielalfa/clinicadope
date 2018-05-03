//
//  ClientesControllerHelper.swift
//  MasterApp
//
//  Created by Gabriel Seben on 01/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import CoreData

extension ClientesController {
    
    func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
   }
    
    func clearData()  {
        
        let fetchRequest:NSFetchRequest<Message> = Message.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        let fetchRequest1:NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest:fetchRequest1 as! NSFetchRequest<NSFetchRequestResult>)
        
        do{
            try getContext().execute(deleteRequest)
            try getContext().execute(deleteRequest1)
            print("Delete All Containers")
        }catch let err{
           print(err.localizedDescription)
        }
        
    }
    
    func setupData(){
        
        clearData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: context) as! Cliente
        mark.name = "Mark Zuberberg"
        mark.profileImageName = "user"
        
        ClientesController.createMessagetext(text: "Hello, my name is Mark, nice to meet you...", cliente: mark, minutesAgo: 90, context: context)
        
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: context) as! Cliente
        steve.name = "Steve Jobs"
        steve.profileImageName = "rocket"
        
        ClientesController.createMessagetext(text: "Hello, my name is Steve, nice to meet you...", cliente: steve, minutesAgo: 120, context: context)
       
        let jonh = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: context) as! Cliente
        jonh.name = "Jonh Lennon"
        jonh.profileImageName = "dog"
        
        ClientesController.createMessagetext(text: "Hello, my name is Jonh, nice to meet you...", cliente: jonh, minutesAgo: 24 * 60, context: context)
        
        createMessagesPaul(context: context)
       
        let gandi = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: context) as! Cliente
        gandi.name = "Mahatma Gandi"
        gandi.profileImageName = "man"
        
        ClientesController.createMessagetext(text: "Good Morning1", cliente: gandi, minutesAgo: 8 * 24 * 60, context: context)
        
        
        do{
            try(context.save())
        }catch let err{
            print(err)
        }
        
        loadData_Filter()
        
    }
    private func createMessagesPaul(context: NSManagedObjectContext){
        
        let paul = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: context) as! Cliente
        paul.name = "Paul McCartney"
        paul.profileImageName = "cat"
        
        ClientesController.createMessagetext(text: "Good Morning1 Are you interessant in bulding an Apple device?", cliente: paul, minutesAgo: 20, context: context)
        ClientesController.createMessagetext(text: "How are you...Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?", cliente: paul, minutesAgo: 1, context: context)
        ClientesController.createMessagetext(text: "Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?", cliente: paul,minutesAgo: 110, context: context)
        
        //Response message
        ClientesController.createMessagetext(text: "Yes, totaly looking  to b iPhone 7", cliente: paul,minutesAgo: 30, context: context, isSender: true)
        
        ClientesController.createMessagetext(text: "Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?", cliente: paul,minutesAgo: 0, context: context)
        
        ClientesController.createMessagetext(text: "Yes, totaly looking  to b iPhone 7", cliente: paul,minutesAgo: 30 * 30, context: context, isSender: true)
        
        ClientesController.createMessagetext(text: "Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?Are you interessant in bulding an Apple device?", cliente: paul,minutesAgo: 0, context: context)
        
        ClientesController.createMessagetext(text: "Yes, totaly looking  to b iPhone 7", cliente: paul,minutesAgo: 10, context: context, isSender: true)
        
        
        
    }
    
  static public func createMessagetext(text: String, cliente: Cliente, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.cliente = cliente
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60) as Date
        message.isSender = NSNumber(value: isSender) as! Bool
        return message
    }
    
    
    func loadData()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        do{
           // messages = try context.fetch(fetchRequest)
            //messages = (try context.fetch(Message.fetchRequest()) as? [Message])!
            
        }catch let err{
            print(err)
        }
    }
    
    func loadData_Filter()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        
        if let clientes = fetchCliente() {
//
//            messages = [Message]()
//
//            for cliente in clientes{
//
//                let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
//                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//                fetchRequest.predicate = NSPredicate(format: "cliente.name = %@", cliente.name!)
//                fetchRequest.fetchLimit = 1
//
//                do{
//                    let fetchMessages = try context.fetch(fetchRequest) as? [Message]
//                    messages?.append(contentsOf: fetchMessages!)
//                }catch let err{
//                    print(err)
//                }
//            }
//            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
        }
        
    }
    
    
    private func fetchCliente() -> [Cliente]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        
         let fetchRequest = NSFetchRequest<Cliente>(entityName: "Cliente")
        
        do{
            return try context.fetch(fetchRequest)
        }
        catch let err{
            print(err)
        }
        return nil
    }
    
    
}






