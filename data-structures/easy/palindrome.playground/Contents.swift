/*
 409. Longest Palindrome
 Easy

 Given a string s which consists of lowercase or uppercase letters, return the length of
 the longest palindrome that can be built with those letters.
 Letters are case sensitive, for example, "Aa" is not considered a palindrome.

 Example 1:
 Input: s = "abccccdd"
 Output: 7
 
 Explanation: One longest palindrome that can be built is "dccaccd", whose length is 7.
 
 Example 2:
 Input: s = "a"
 Output: 1
 
 Explanation: The longest palindrome that can be built is "a", whose length is 1.

 Constraints:
 1 <= s.length <= 2000
 s consists of lowercase and/or uppercase English letters only.
 */

class Solution {
    func longestPalindrome(_ s: String) -> Int {
        var dict = [Character: Int]()
        var result = 0
        var oddFound = false

        for c in s {
            dict[c, default: 0] += 1
        }
        
        for v in dict.values {
            if v % 2 != 0 && oddFound == false {
                oddFound = true
            }
            result += (v / 2) * 2
        }
        
        return oddFound ? result + 1 : result
    }
}

let a = Solution().longestPalindrome("abccccdd") // 7
let b = Solution().longestPalindrome("a") // 1
