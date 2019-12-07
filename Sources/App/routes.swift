import Vapor

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
}
