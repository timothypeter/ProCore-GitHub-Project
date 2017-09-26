//
//  GitHub.swift
//  ProCore GitHub Project
//
//  Created by Timothy Peter on 9/25/17.
//  Copyright © 2017 Timothy Peter. All rights reserved.
//

import Foundation

enum GitHubError: Error {
    case unknown
    case notFound
    case malformedData
}

protocol GitHubObject: Codable {
    
    // Returns the path of the object
    static func path() -> String
}

class Diff {
    
    var rawValue: String? // The raw diff file
    var files: [File] = []
    
    init(rawValue: String?) {
        self.rawValue = rawValue
        parse()
    }
    
    fileprivate func parse() {
        guard let rawValue = rawValue else {
            return
        }
        let lines = rawValue.components(separatedBy: .newlines)
        for line in lines {
            if hasMatch(File.pattern, line: line) { // Check if we are starting a new diff file
                let file = File(line)
                files.append(file)
            } else if hasMatch(Hunk.pattern, line: line) { // Check if we are starting a new hunk
                
                if let currentFile = files.last {
                    let hunk = Hunk(line)
                    currentFile.hunks.append(hunk)
                }
                
                
            } else { // Append to the current hunk
                if let currentFile = files.last, let currentHunk = currentFile.hunks.last {
                    if line.starts(with: "-") { // Show deletions on the left
                        currentHunk.leftLines.append(line)
                    } else if line.starts(with: "+") { // Additions on the right
                        currentHunk.rightLines.append(line)
                    } else {
                        currentHunk.leftLines.append(line)
                        currentHunk.rightLines.append(line)
                    }
                }
            }
        }
    }
    
    // Checks to see if the line is of a particular match
    fileprivate func hasMatch(_ pattern: String, line: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: line, options: .reportCompletion, range: NSMakeRange(0, line.utf16.count))
            return !matches.isEmpty
        } catch {
            
        }
        return false
    }
}

class File {
    
    static let pattern = "diff --git a/(.+) b/(.+)"
    
    var leftName: String?
    var rightName: String?
    var hunks: [Hunk] = []
    
    convenience init(_ line: String) {
        self.init()
        parse(line)
    }
    
    fileprivate func parse(_ line: String) {
        do {
            let regex = try NSRegularExpression(pattern: File.pattern, options: .caseInsensitive)
            let matches = regex.matches(in: line, options: .reportCompletion, range: NSMakeRange(0, line.utf16.count))
            if !matches.isEmpty {
                for match in matches {
                    
                    let lineToPass: NSString = line as NSString
                    leftName = "\(lineToPass.substring(with: match.range(at: 1)) )"
                    rightName = "\(lineToPass.substring(with: match.range(at: 2)) )"
                }
            }
        } catch {
            print("Unable to parse file: \(error)")
        }
    }
}

class Hunk {
    
    static let pattern = "@@ \\-([0-9]+),([0-9]+) \\+([0-9]+),([0-9]+) @@(.+)?"
    
    var desc: String?
    var leftStartLine: Int = 0
    var leftNumberOfLines: Int = 0
    var rightStartLine: Int = 0
    var rightNumberOfLines: Int = 0
    var leftLines: [String] = []
    var rightLines: [String] = []
    
    var linesChanged: Int {
        get {
            return max(leftLines.count, rightLines.count)
        }
    }
    
    convenience init(_ line: String) {
        self.init()
        desc = line
        parse(line)
    }
    
    fileprivate func parse(_ line: String) {
        do {
            let regex = try NSRegularExpression(pattern: Hunk.pattern, options: .caseInsensitive)
            let matches = regex.matches(in: line, options: .reportCompletion, range: NSMakeRange(0, line.utf16.count))
            if !matches.isEmpty {
                for match in matches {
                    
                    let lineToPass: NSString = line as NSString
                    let group1 = lineToPass.substring(with: match.range(at: 1))
                    let group2 = lineToPass.substring(with: match.range(at: 2))
                    let group3 = lineToPass.substring(with: match.range(at: 3))
                    let group4 = lineToPass.substring(with: match.range(at: 4))
                    
                    
                    leftStartLine = Int(group1) ?? 0
                    leftNumberOfLines = Int(group2) ?? 0
                    rightStartLine = Int(group3) ?? 0
                    rightNumberOfLines = Int(group4) ?? 0
                }
            }
        } catch {
            print("Unable to parse file: \(error)")
        }
    }
}
