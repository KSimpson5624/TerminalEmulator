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
    @State private var prompt: String = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(output)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.green)
                            .font(.custom("JetBrainsMono-Regular", size: 12))
                        
                        Color.clear
                            .frame(height: 1)
                            .id("BOTTOM")
                    }
                }
                .onChange(of: output) {
                    withAnimation {
                        proxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }
            //Divider()
            HStack {
                Text(prompt)
                    .foregroundColor(.green)
                    .font(.custom("JetBrainsMono-Regular", size: 12))
            
            
                TextField("", text: $input, onCommit: runCommand)
                    .textFieldStyle(.plain)
                    .foregroundColor(.green)
                    .background(Color.clear)
                    .font(.custom("JetBrainsMono-Regular", size: 12))
                    
                    
            }
        }
        .padding()
        .onAppear {
            prompt = getPrompt()
        }
    }
    
    func runCommand() {
        guard !input.isEmpty else { return }
        
        let result = executeShellCommand(input)
        prompt = getPrompt()
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
