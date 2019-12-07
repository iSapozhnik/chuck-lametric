import Vapor

/*
 {
     "frames": [
         {
             "icon":"i3219",
             "text":"3"
         }
     ]
 }
 
 {
 "icon_url" : "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
 "id" : "h1wmJ-T6SzmLyJjtJRV0cQ",
 "url" : ""
 "value" : "Chuck Norris recently guested on Hardcore Pawn, where he sold some pocket lint for 8.5 million dollars. Then he brutally roundhose kicked the owner for not actually having any porn."
 }
 
 */

struct Frame: Codable, Content {
    var frames: [Response]
}

struct Response: Codable, Content {
    var icon: String
    var text: String
}

struct ChuckFact: Codable, Content {
    var value : String

}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req -> Future<Frame> in
        let res = try req.client().get("https://api.chucknorris.io/jokes/random")
        let chuckFact = res.flatMap(to: ChuckFact.self) { response in
            return try! response.content.decode(ChuckFact.self)
        }.map(to: Frame.self, { fact -> Frame in
            return Frame(frames: [Response(icon: "i32945", text: fact.value)])
        })

        return chuckFact
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
