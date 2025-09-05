/*
 1309. Decrypt String from Alphabet to Integer Mapping - Easy

 You are given a string s formed by digits and '#'. We want to map s to English lowercase characters as follows:

 Characters ('a' to 'i') are represented by ('1' to '9') respectively.
 Characters ('j' to 'z') are represented by ('10#' to '26#') respectively.
 Return the string formed after mapping.

 The test cases are generated so that a unique mapping will always exist.

 Example 1:
 Input: s = "10#11#12"
 Output: "jkab"
 Explanation: "j" -> "10#" , "k" -> "11#" , "a" -> "1" , "b" -> "2".
 
 Example 2:
 Input: s = "1326#"
 Output: "acz"
  
 Constraints:
 1 <= s.length <= 1000
 s consists of digits and the '#' letter.
 s will be a valid string such that mapping is always possible.
 */

class Solution {
    func freqAlphabets(_ s: String) -> String {
        let az = "abcdefghijklmnopqrstuvwxyz"
        var dict: [String: String] = [:]
        for (index, letter) in az.enumerated() {
            dict[String(index+1)] = String(letter)
        }

        var array = s.split(separator: "#")
        print(array)
        
        let result = array.map { breakNumber(String($0)) }
        return result
    }
    
    func breakNumber(_ s: String) -> [String] {
        var nums = s.map { String($0) }
        if nums.count >= 2 {
            let doubleDigit = Int(nums[nums.count-2])! * 10 + Int(nums[nums.count-1])!
            if doubleDigit >= 10 && doubleDigit <= 26 {
                nums.removeLast()
                nums[nums.count-1] = String(doubleDigit)
            }
        }
        return nums
    }
}

Solution().freqAlphabets("10#11#12")
Solution().freqAlphabets("1326#")

