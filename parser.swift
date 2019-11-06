import Swift
import Foundation

// TODO: read from any file name
func parseRooms() -> [Room] {
  let path = "/Users/ericandrews/Desktop/rooms.json"

  do {
    let jsonString = try String(contentsOfFile: path)

    let jsonData = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()
    let r = try! decoder.decode(RoomData.self, from: jsonData)
    
    return r.allRooms
  }
  catch {
    let r: [Room] = []
    return r
  }
}

// helper function
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// call a shell function to move autoRooms.json from documents to desktop
func move(destName: String) {
  // Create a Task instance
  let task = Process()

  // Set the task parameters
  task.launchPath = "/usr/bin/env"
  task.arguments = ["mv",
                    "/Users/ericandrews/Documents/autoRooms.json",
                    "/Users/ericandrews/Desktop/" + destName]
  // Launch the task
  task.launch()
}

// should write to desktop but that's apparently very difficult
// TODO: write to any file name, not just autoRooms.json
func writeRooms(rooms: [Room]) {
  let rData: RoomData = RoomData(allRooms: rooms)

  let jsonData = try! JSONEncoder().encode(rData)
  let jsonString = String(data: jsonData, encoding: .utf8)!

  let path = getDocumentsDirectory().appendingPathComponent("autoRooms.json")

  do {
    try jsonString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
    move(destName: "autoRooms.json") // put it in the right directory
  }
  catch let error as NSError {
    print("Error writing to file")
    print(error)
  }
}

func parseAttributes() -> Attributes {
  let path = "/Users/ericandrews/Desktop/attributes.json"

  do {
    let jsonString = try String(contentsOfFile: path)
    
    let jsonData = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()
    let a = try! decoder.decode(Attributes.self, from: jsonData)
    
    return a
  }
  catch {
    return Attributes(passages: ["!!!"],
                      lights: ["!!!"],
                      flavors: ["!!!"],
                      features: ["!!!"],
                      friendlyEncounters: ["!!!"],
                      hostileEncounters: ["!!!"])
  }
}
