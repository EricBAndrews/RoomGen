import Swift
import Foundation

func printOpts() {
  print("l: load rooms")
  print("s: save rooms")
  print("v: view room")
  print("n: new room")
}

func loadRooms() -> [Room] {
  print("reading rooms from rooms.json...")
  var rooms = parseRooms()
  if (rooms.count == 0) {
    print("something went wrong! no rooms parsed")
  }
  else {
    print("done!")
  }
  return rooms
}

func main() {
  // get existing room data
  let attributes = parseAttributes()
  var rooms: [Room] = loadRooms()
  var usrIn: String = ""
  while (usrIn != "q") {
    print("enter your selection (\"o\" for options)")
    usrIn = readLine()!
    if (usrIn == "q") {
      print("press n to not save, any other key to save")
      let save: String = readLine()!
      if (save == "n") { break }
      else { writeRooms(rooms: rooms) }
    }
    
    switch usrIn {
    case "l":
      rooms = loadRooms()
    case "o":
      printOpts()
    case "v":
      print("room to view:")
      let roomId = Int(readLine()!) ?? -1
      if (roomId < rooms.count && roomId >= 0) {
        printRoom(r: rooms[roomId], a: attributes)
      }
      else {
        print("invalid room id! try again.") 
      }
    case "s":
      print("saving rooms...")
      writeRooms(rooms: rooms)
    case "n":
      print("generating new room...")
      let newRoom = roomGen(nPassages: attributes.passages.count,
                            nLights: attributes.lights.count,
                            nFlavors: attributes.flavors.count,
                            nFeatures: attributes.features.count,
                            nFriendly: attributes.friendlyEncounters.count,
                            nHostile: attributes.hostileEncounters.count)
      printRoom(r: newRoom, a: attributes)
      rooms.append(newRoom)
    default:
      print("unknown option. try again!")
    }
  }
}

main()
