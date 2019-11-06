import Swift
import Foundation

// TODO: read from any file name
func parseRooms() -> [Room] {
  if let path = Bundle.main.path(forResource: "rooms",
                                ofType: "json",
                                inDirectory: "jsonFiles") {

    do {
      let jsonString = try String(contentsOfFile: path)

      let jsonData = jsonString.data(using: .utf8)!
      let decoder = JSONDecoder()
      let r = try! decoder.decode(RoomData.self, from: jsonData)
      
      return r.allRooms
    }
    catch {
      print("something went wrong loading file")
      print("PATH: " + path)
      let r: [Room] = []
      return r
    }
  }
  else {
    let r: [Room] = []
    return r
  }
}

// helper function
func getDocumentsDirectory() -> URL {
  let paths = FileManager.default.urls(for: .documentDirectory,
                                       in: .userDomainMask)
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
                    destName]
  // Launch the task
  task.launch()
}

// writes to autoRooms.json; this still must be manually changed
// to protect against bad writes
// TODO: generate rooms backup, write to rooms.json
func writeRooms(rooms: [Room]) {
  let rData: RoomData = RoomData(allRooms: rooms)

  let jsonData = try! JSONEncoder().encode(rData)
  let jsonString = String(data: jsonData, encoding: .utf8)!

  if let destPath = Bundle.main.path(forResource: "autoRooms",
                                     ofType: "json",
                                     inDirectory: "jsonFiles") {

    do {
      let path = getDocumentsDirectory().appendingPathComponent(
        "autoRooms.json")
      try jsonString.write(to: path,
                           atomically: false,
                           encoding: String.Encoding.utf8)
      move(destName: destPath)
    }
    catch let error as NSError {
      print("error writing to file")
      print(error)
    }
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
