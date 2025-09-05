func decipher(sentence: String, knownWord: String) -> String {
    let words = sentence.split(separator: " ")
    let potential = words.filter { $0.count == knownWord.count }
    return ""
}

func buildMapping() {
    
}

let secretSentence = "deab xzy qwert"
let knownWord = "cafe"

decipher(sentence: secretSentence, knownWord: knownWord)


func buildMapping(secret: String, known: String) -> [Character: Character]? {
    var mapping: [Character: Character] = [:]

    for (sChar, kChar) in zip(secret, known) {
        if let existing = mapping[sChar], existing != kChar {
            return nil // conflict
        }
        mapping[sChar] = kChar
    }
    return mapping
}

func applyMapping(to sentence: String, mapping: [Character: Character]) -> String {
    return String(sentence.map { mapping[$0] ?? $0 })
}

