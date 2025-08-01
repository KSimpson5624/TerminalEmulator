//
//  TerminalView.swift
//  SwiftTermEmulator
//
//  Created by Kyle Simpson on 7/28/25.
//

import SwiftUI

struct TerminalView: View {
    
    @State private var input: String = ""
    @State private var output: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                Text(output)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            Divider()
            HStack {
                TextField("Enter command", text: $input, onCommit: runCommand)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 400)
                    .padding()
                    .focusable(true)
            }
        }
        .padding()
    }
    
    func runCommand() {
        guard !input.isEmpty else { return }
        
        let result = executeShellCommand(input)
        let prompt = getPrompt()
        output += "\(prompt) \(input)\n\(result)\n"
        input = ""
    }
    
    func getPrompt() -> String {
        let username = NSUserName()
        let hostname = Host.current().localizedName ?? "Unknown Host"
        let path = FileManager.default.currentDirectoryPath
        let shortpath = path.replacingOccurrences(of: NSHomeDirectory(), with: "~")
        
        return "\(username)@\(hostname) \(shortpath) %"
    }
}

#Preview {
    TerminalView()
}
