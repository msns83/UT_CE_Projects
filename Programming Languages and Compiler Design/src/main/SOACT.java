package main;

import main.ast.nodes.Soact;
import main.symbolTable.SymbolTable;
import main.visitor.CodeGenerator;
import main.visitor.NameAnalyzer;
import main.visitor.TypeChecker;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import parsers.SOACTLexer;
import parsers.SOACTParser;

import java.io.*;
import java.util.Arrays;

public class SOACT {
    public static void main(String[] args) throws IOException {
        CharStream reader = CharStreams.fromFileName(args[0]);
        SOACTLexer soactLexer = new SOACTLexer(reader);
        CommonTokenStream tokens = new CommonTokenStream(soactLexer);
        SOACTParser soactParser = new SOACTParser(tokens);
        Soact soact = soactParser.soact().soactRet;
        NameAnalyzer nameAnalyzer = new NameAnalyzer();
        nameAnalyzer.visit(soact);

//        TypeChecker typeChecker = new TypeChecker();
//        typeChecker.visit(soact);

        SymbolTable.top.hashCode();

        CodeGenerator codeGenerator = new CodeGenerator();
        codeGenerator.visit(soact);

        runJasminCode();
    }


    private static void runJasminCode() {
        try {
//            System.out.println("---------------------------Compilation Successful---------------------------");
            File dir = new File("./codeGenOutput");

            // Debug: Print directory and .j files
            // System.out.println("Jasmin output directory: " + dir.getAbsolutePath());
            // String[] jFiles = dir.list((d, name) -> name.endsWith(".j"));
            // System.out.println("Generated .j files: " + Arrays.toString(jFiles));

            Process jasminProcess = Runtime.getRuntime().exec(
                new String[]{"sh", "-c", "java -jar jasmin.jar *.j"},
                null,
                dir
            );

            int exitCode = jasminProcess.waitFor();
            if (exitCode != 0) {
                System.err.println("Jasmin Compilation Failed!");
                printResults(jasminProcess.getErrorStream());
                return;
            }

            Process runProcess = Runtime.getRuntime().exec(
                new String[]{"java", "-cp", ".", "Main"},
                null,
                dir
            );
            printResults(runProcess.getInputStream());
            printResults(runProcess.getErrorStream());

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }


//    private static void runJasminCode() {
//        try {
//            File dir = new File("./codeGenOutput");
//            File[] jasminFiles = dir.listFiles((d, name) -> name.endsWith(".j"));
//            if (jasminFiles == null || jasminFiles.length == 0) {
//                return;
//            }
//
//            StringBuilder jasminCommand = new StringBuilder("java -jar jasmin.jar");
//            for (File jFile : jasminFiles) {
//                jasminCommand.append(" ").append(jFile.getName());
//            }
//
//            Process process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", jasminCommand.toString()}, null, dir);
//            printResults(process.getInputStream());
//            printResults(process.getErrorStream());
//
//            process.waitFor();
//            process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", "java Main"}, null, dir);
//            printResults(process.getInputStream());
//            printResults(process.getErrorStream());
//        } catch (IOException | InterruptedException e) {
//            e.printStackTrace();
//        }
//    }

    private static void printResults(InputStream stream) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
        String line;
        try {
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}



