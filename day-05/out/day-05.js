"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const fs = __importStar(require("fs"));
const readline = __importStar(require("readline"));
// Get the file path from command line arguments
const filePath = process.argv[2];
// Check if a file path was provided
if (!filePath) {
    console.error('Please provide a file path as an argument.');
    process.exit(1);
}
// Create a readable stream
const fileStream = fs.createReadStream(filePath);
// Create an interface for reading line by line
const rl = readline.createInterface({
    input: fileStream,
    output: process.stdout,
    terminal: false, // Prevents adding extra prompts
});
const rules = new Map();
var middleSum = 0;
const ruleRegex = /^(\d+)\|(\d+)$/;
const updateRegex = /^\d+(?:,\d+)*$/;
// Process each line
rl.on('line', (line) => {
    const ruleMatch = ruleRegex.exec(line);
    const updateMatch = updateRegex.exec(line);
    if (ruleMatch) {
        const before = Number(ruleMatch[1]);
        const after = Number(ruleMatch[2]);
        if (rules.has(before)) {
            rules.get(before)?.add(after);
        }
        else {
            rules.set(before, new Set([after]));
        }
    }
    else if (updateMatch) {
        const pages = updateMatch[0].split(",").map(Number);
        if (pages.every((_, i, array) => {
            if (i === 0)
                return true;
            return rules.get(array[i - 1])?.has(array[i]) ?? false;
        })) {
            middleSum += pages[(pages.length - 1) / 2];
        }
    }
});
// Handle errors
rl.on('error', (err) => {
    console.error('Error reading file:', err.message);
    process.exit(1);
});
// Finish reading
rl.on('close', () => {
    console.log(`Middle Sum: ${middleSum}`);
});
//# sourceMappingURL=day-05.js.map