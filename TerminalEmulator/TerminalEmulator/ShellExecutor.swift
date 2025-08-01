//
//  ShellExecutor.swift
//  SwiftTermEmulator
//
//  Created by Kyle Simpson on 7/28/25.
//

import Foundation

func executeShellCommand(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    
    do {
        try task.run()
    } catch {
        return "Error running command: \(error)"
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8) ?? ""
}
