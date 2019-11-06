// STRUCTS
// single encounter
struct Encounter: Codable {
  let friendly: Bool // 1 if friendly
  let id: Int
}

// single room
struct Room : Codable {
  let passage: Int
  let lighting : Int
  let flavor: Int
  let feature: Int
  let exits: Int
  let width: Int
  let length: Int
  let encounter: Encounter
}

// for json parsing purposes
struct RoomData: Codable {
  var allRooms: [Room]
}

// holds the master list of attributes for selection/output
struct Attributes : Codable {
  let passages: [String]
  let lights: [String]
  let flavors: [String]
  let features: [String]
  let friendlyEncounters: [String]
  let hostileEncounters: [String]
}

// FUNCTIONS
// generates a random number from a roughly normal distribution 15-60
func numGen() -> Int {
  let n1: Int = Int.random(in: 3 ... 12)
  let n2: Int = Int.random(in: 3 ... 12)
  let n3: Int = Int.random(in: 3 ... 12)
  return (n1 + n2 + n3) / 3 * 5
}

// prints a description of the room
func printRoom(r: Room, a: Attributes) {
  let w: String = String(r.width)
  let l: String = String(r.length)
  print(String(repeating: "=", count: 80))
  print("The passage to the room is " + a.passages[r.passage] + ".")
  print("The room measures " + String(w) + " by " + String(l) + 
          ", and is illuminated by " + a.lights[r.lighting] + ".")
  print(a.flavors[r.flavor] + ".")
  if (r.exits > 1) {
    print("There are " + String(r.exits) + " passages out.")
  }
  else {
    print("There is 1 passage out.")
  }
  if (r.encounter.friendly) {
    print("ENCOUNTER: " + a.friendlyEncounters[r.encounter.id])
  }
  else {
    print("ENCOUNTER: " + a.hostileEncounters[r.encounter.id])
  }
  // TODO: set count to be environment terminal width (low priority)
  print(String(repeating: "=", count: 80))
}

// generates and returns a random room
func roomGen(nPassages: Int,
             nLights: Int,
             nFlavors: Int,
             nFeatures: Int,
             nFriendly: Int,
             nHostile: Int) -> Room {
  var enc: Encounter
  if (Bool.random()) {
    enc = Encounter(friendly: true, id: Int.random(in: 0 ..< nFriendly))
  }
  else {
    enc = Encounter(friendly: false, id: Int.random(in: 0 ..< nHostile))
  }
  return Room(passage: Int.random(in: 0 ..< nPassages),
              lighting: Int.random(in: 0 ..< nLights),
              flavor: Int.random(in: 0 ..< nFlavors),
              feature: Int.random(in: 0 ..< nFeatures),
              exits: Int.random(in: 1 ..< 4),
              width: numGen(),
              length: numGen(),
              encounter: enc)
}
