package main.visitor;

import main.ast.nodes.Soact;
import main.ast.nodes.declaration.*;
import main.ast.nodes.expression.*;
import main.ast.nodes.expression.operator.BinaryOperator;
import main.ast.nodes.expression.value.IntValue;
import main.ast.nodes.expression.value.StringValue;
import main.ast.nodes.statements.*;
import main.ast.nodes.type.*;
import main.symbolTable.SymbolTable;
import main.symbolTable.exceptions.ItemNotFound;
import main.symbolTable.items.ActorDecItem;
import main.symbolTable.items.ServiceHandlerItem;
import main.symbolTable.items.SymbolTableItem;
import main.symbolTable.items.VarDeclarationItem;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Objects;

public class CodeGenerator extends Visitor<String> {
    private final String outputPath;
    private FileWriter currentFile;
    private boolean isField = false ;
    HashMap<String, String> jasminTypes = new HashMap<>();
    private String currentMethod ;
    private SymbolTable currentSymbolTable ;
    private int currentIndex = 1 ;
    private HashSet<String> set;

    public CodeGenerator() {
        outputPath = "./codeGenOutput/";

        jasminTypes.put(IntType.class.getSimpleName(), "I");
        jasminTypes.put(StringType.class.getSimpleName(), "Ljava/lang/String;");
        jasminTypes.put(BooleanType.class.getSimpleName(), "Z");
        jasminTypes.put(IdType.class.getSimpleName(), "LActor;");

        this.set = new HashSet<>();

        prepareOutputFolder();
    }

    public boolean checkAndAdd(String value) {
        if (set.contains(value)) {
            return true;
        } else {
            set.add(value);
            return false;
        }
    }

    private void prepareOutputFolder(){
        String jasminPath = "utilities/jarFiles/jasmin.jar";
        String listClassPath = "utilities/codeGenerationUtilityClasses/List.j";
        String fptrClassPath = "utilities/codeGenerationUtilityClasses/Fptr.j";
        try{
            File directory = new File(this.outputPath);
            File[] files = directory.listFiles();
            if(files != null)
                for (File file : files)
                    file.delete();
            directory.mkdir();
        }
        catch(SecurityException e){
            // ignore
        }
        copyFile(jasminPath, this.outputPath + "jasmin.jar");
        copyFile(listClassPath, this.outputPath + "List.j");
        copyFile(fptrClassPath, this.outputPath + "Fptr.j");
    }

    private void addCommand(String command){
        try {
            currentFile.write( command + "\n");
            currentFile.flush();
        } catch (IOException ignored) {}
    }

    private void copyFile(String toBeCopied, String toBePasted){
        try {
            File readingFile = new File(toBeCopied);
            File writingFile = new File(toBePasted);
            InputStream readingFileStream = new FileInputStream(readingFile);
            OutputStream writingFileStream = new FileOutputStream(writingFile);
            byte[] buffer = new byte[1024];
            int readLength;
            while ((readLength = readingFileStream.read(buffer)) > 0)
                writingFileStream.write(buffer, 0, readLength);
            readingFileStream.close();
            writingFileStream.close();
        } catch (IOException e){
            // ignore
        }
    }

    private void createFile(String name) {
        try {
            String path = this.outputPath + name + ".j";
            File file = new File(path);
            file.createNewFile();
            this.currentFile = new FileWriter(path);
        } catch (IOException ignored) {}
    }

    private void appendToActorFile(String commands, String methodName) {

        if (!checkAndAdd(methodName)) {
            try {
                FileWriter tempVar = currentFile ;
                String path = this.outputPath + "Actor.j";
                File file = new File(path);
                this.currentFile =  new FileWriter(file, true);

                addCommand("\n" + commands);

                this.currentFile.close();
                currentFile = tempVar ;
            } catch (IOException ignored) {}
        }

    }


    @Override
    public String visit(Soact soact) {
        createFile("Actor");

        String commands = """
                .class public Actor
                .super java/lang/Object
                
                .method public <init>()V
                    .limit stack 10
                    .limit locals 10
                    aload_0
                    invokespecial java/lang/Object/<init>()V
                    return
                .end method""";

        addCommand(commands);

        currentIndex = 1 ;
        for (ActorDec actorDec : soact.getActorDecs()) {
            actorDec.accept(this);
        }

        currentIndex = 0 ;
        if (soact.getMain() != null) {
            soact.getMain().accept(this);
        }

        return null;
    }

    @Override
    public String visit(ActorDec actorDec) {
        createFile(actorDec.getName().getName());
        currentMethod = actorDec.getName().getName() ;

        currentSymbolTable = actorDec.getSymbolTable() ;

        addCommand(".class public " + actorDec.getName().getName()) ;
        addCommand(".super Actor\n");

        isField = true ;
        for (VarDeclaration varDeclaration : actorDec.getActorVars()) {
            varDeclaration.accept(this);
        }
        isField = false;

        addCommand("");

        StringBuilder constructorArgs = new StringBuilder(".method public <init>(");

        for (VarDeclaration arg : actorDec.getConstructorArgs()) {
           constructorArgs.append(jasminTypes.get(arg.getType().getClass().getSimpleName()));
        }

        constructorArgs.append(")V");
        addCommand(constructorArgs.toString());

        String commands = """
                    \t.limit stack 128
                    \t.limit locals 128
                    \taload_0
                    \tinvokespecial Actor/<init>()V""" ;
        addCommand(commands);

        currentSymbolTable = actorDec.getConstructorSymbolTable() ;
        currentIndex = 1 ;
        for (VarDeclaration arg : actorDec.getConstructorArgs()){
            arg.accept(this);
        }

        for (Statement statement : actorDec.getConstructorBody()) {
            statement.accept(this);
        }

        addCommand("\treturn\n.end method");

        addCommand("");

        currentSymbolTable = actorDec.getSymbolTable() ;

        for (Handler handler : actorDec.getMsgHandlers()) {
            currentIndex = 1 ;
            handler.accept(this);
        }

        return null;
    }

    private void fieldDeclare(VarDeclaration varDeclaration){
        String commands = ".field public " + varDeclaration.getName().getName() + " " ;

        try {
            SymbolTableItem argument = currentSymbolTable.getItem("VarDeclaration_"+varDeclaration.getName().getName());
            argument.setLocalIndex(-2);
        } catch (ItemNotFound ignored) {}

        commands += jasminTypes.get(varDeclaration.getType().getClass().getSimpleName());
        addCommand(commands);
    }

    @Override
    public String visit(VarDeclaration varDeclaration) {



        if (isField){
            fieldDeclare(varDeclaration);
        } else {
            try {
                SymbolTableItem argument = currentSymbolTable.getItem("VarDeclaration_"+varDeclaration.getName().getName());
                argument.setLocalIndex(currentIndex);
                currentIndex++ ;
            } catch (ItemNotFound ignored) {}
        }

        return String.valueOf(currentIndex - 1);
    }


    @Override
    public String visit(Main main) {
        createFile("Main");
        currentMethod = "Main";
        currentSymbolTable = main.getSymbolTable();

        String commands = """
                .class public Main
                .super java/lang/Object
                
                .method public static main([Ljava/lang/String;)V
                    .limit stack 128
                    .limit locals 128
                    new Main
                    invokespecial Main/<init>()V""";

        addCommand(commands);

        for (Statement statement : main.getStatements()) {
            statement.accept(this);
        }

        addCommand("\treturn\n.end method");

        commands = """
              
                .method public <init>()V
                    .limit stack 128
                    .limit locals 128
                    aload_0
                    invokespecial java/lang/Object/<init>()V
                    return
                .end method""";
        addCommand(commands);

        return null;
    }

    private boolean arrayMode = false ;
    private String arrayNum = "-1" ;
    private int arrayIndex = 0 ;

    @Override
    public String visit(InitStatement initStatement) {
        String index = initStatement.getAssignee().accept(this);

        if (initStatement.getAssignee().arrayType){
            arrayMode = true;
            String commands = """
                    \tnew List
                    \tdup
                    \tnew java/util/ArrayList
                    \tdup
                    """;
            commands += "\tbipush " + initStatement.getAssignee().getArrayIndex().getIndex() + "\n" ;
            commands += """
                    \taconst_null
                    \tinvokestatic java/util/Collections/nCopies(ILjava/lang/Object;)Ljava/util/List;
                    \tinvokespecial java/util/ArrayList/<init>(Ljava/util/Collection;)V
                    \tinvokespecial List/<init>(Ljava/util/ArrayList;)V
                    """;
            
            commands += "\tastore " + index ;
            addCommand(commands);
            arrayNum =  index ;
        }

        arrayIndex = 0 ;
        if (initStatement.getAssigned() != null){
            initStatement.getAssigned().accept(this);
        }

        if (!arrayMode && initStatement.getAssigned() != null){
            if (initStatement.getAssignee().getType().getClass().getSimpleName().equals("IntType")){
                addCommand("\tistore " + index);
            } else {
                addCommand("\tastore " + index);
            }
        }



        arrayMode = false;
        arrayIndex = 0 ;

        return null;
    }

    @Override
    public  String visit(ConstructorExpression constructorExpression){
        addCommand("\tnew " + constructorExpression.getId().getName());
        addCommand("\tdup");

        String types = constructorExpression.getArgs().accept(this);
        addCommand("\tinvokespecial " + constructorExpression.getId().getName() + "/<init>(" + types + ")V");

        return null;
    }

    @Override
    public String visit(ExpressionList expressionList){
        StringBuilder types = new StringBuilder();

        for (Expression expression : expressionList.getExpressionList()){
            if (arrayMode){
                addCommand("\taload " + arrayNum);
                addCommand("\tbipush " + arrayIndex);
                arrayIndex += 1 ;
            }

            String type = expression.accept(this);

            if (arrayMode){
                addCommand("\tinvokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;");
            }

            if (Objects.equals(jasminTypes.get(type), jasminTypes.get("undifiend"))){
                types.append("L").append(type).append(";");
            } else {
                types.append(jasminTypes.get(type));
            }

            if (arrayMode){
                addCommand("\tinvokevirtual List/setElement(ILjava/lang/Object;)V");
            }
        }

        return types.toString();
    }

    @Override
    public String visit(ServiceHandler serviceHandler) {
        currentSymbolTable = serviceHandler.getSymbolTable() ;
        currentIndex = 1 ;
        StringBuilder commands = new StringBuilder(".method public " + serviceHandler.getName().getName() + "(");


        for (VarDeclaration arg : serviceHandler.getArgs()) {
            arg.accept(this);
            if (arg.getType().getClass().getSimpleName().equals("OtherType")){
                commands.append("L").append(((OtherType) arg.getType()).getName()).append(";");
            } else {
                commands.append(jasminTypes.get(arg.getType().getClass().getSimpleName()));
            }
        }

        commands.append(")V\n").append("\t.limit stack 128\n\t.limit locals 128\n");
        addCommand(commands.toString());
        commands.append("\treturn\n.end method\n");
        appendToActorFile(commands.toString(), serviceHandler.getName().getName());



        for (Statement statement : serviceHandler.getBody()) {
            statement.accept(this);
        }

        for (Expression expr : serviceHandler.getAuthorizationExpressions()) {
            expr.accept(this);
        }

        addCommand("\treturn\n.end method\n");

        return null;
    }

    @Override
    public String visit(ObserveHandler observeHandler) {
        currentSymbolTable = observeHandler.getSymbolTable() ;
        currentIndex = 1 ;
        StringBuilder commands = new StringBuilder(".method public " + observeHandler.getName().getName() + "_OBSERVE" + "(");

        for (VarDeclaration arg : observeHandler.getArgs()) {
            arg.accept(this);
            if (arg.getType().getClass().getSimpleName().equals("OtherType")){
                commands.append("L").append(((OtherType) arg.getType()).getName()).append(";");
            } else {
                commands.append(jasminTypes.get(arg.getType().getClass().getSimpleName()));
            }
        }

        commands.append(")V\n").append("\t.limit stack 128\n\t.limit locals 128\n");
        addCommand(commands.toString());
        commands.append("\treturn\n.end method\n");
        appendToActorFile(commands.toString(), observeHandler.getName().getName() + "_OBSERVE");


        for (Statement statement : observeHandler.getBody()) {
            statement.accept(this);
        }

        for (Expression expr : observeHandler.getAuthorizationExpressions()) {
            expr.accept(this);
        }

        addCommand("\treturn\n.end method\n");

        return null;
    }

    @Override
    public String visit(AssignmentStatement assignmentStatement) {
        ArrayList<Identifier> leftSide = assignmentStatement.getIds() ;

        for (Identifier id : leftSide) {
            if (Objects.equals(id.getName(), "self")){
                addCommand("\taload_0");
                break;
            }
        }

        assignmentStatement.getAssigned().accept(this);

        if (Objects.equals(leftSide.getFirst().getName(), "self")){
            String commands = "\tputfield " + currentMethod + "/" + leftSide.get(1).getName() + " " ;
            try {
                SymbolTableItem item = currentSymbolTable.getItem("VarDeclaration_"+ leftSide.get(1).getName()) ;
                VarDeclaration variable = ((VarDeclarationItem) item).varDeclaration ;
                commands += jasminTypes.get(variable.getType().getClass().getSimpleName());
            }  catch (ItemNotFound ignored) {}

            addCommand(commands);
        } else {
            try {
                VarDeclarationItem localVar = (VarDeclarationItem) currentSymbolTable.getItem("VarDeclaration_"+leftSide.getFirst().getName());
                if (localVar.varDeclaration.getType().getClass().getSimpleName().equals("IntType")){
                    addCommand("\tistore "+ localVar.getLocalIndex());
                }else {
                    addCommand("\tastore "+ localVar.getLocalIndex());
                }
            } catch (ItemNotFound ignored) {}

        }

        return null;
    }

    @Override
    public String visit(ExpressionStatement expressionStatement) {
        expressionStatement.getExpression().accept(this);
        return null;
    }

    @Override
    public  String visit(AccessExpression accessExpression){
        String name = ((Identifier) accessExpression.getLeft()).getName();
        VarDeclaration variable ;

        try {
            SymbolTableItem variableItem = currentSymbolTable.getItem("VarDeclaration_"+name);
            variable = ((VarDeclarationItem) variableItem).varDeclaration ;
            name = ((OtherType) variable.getType()).getName() ;
        } catch (ItemNotFound ignored) {}

        ArrayList<VarDeclaration> args = new ArrayList<>() ;
        String handlerName = ((CallExpression) accessExpression.getRight()).getIdentifier().getName() ;

        try {
            SymbolTableItem variableItem = currentSymbolTable.getItem("ActorDec_"+name);
            variableItem = ((ActorDecItem) variableItem).getActorDec().getSymbolTable().getItem("ServiceHandler_"+ handlerName) ;
            args = ((ServiceHandlerItem) variableItem).getServiceHandler().getArgs() ;
        } catch (ItemNotFound ignored) {}


        accessExpression.getLeft().accept(this);
        accessExpression.getRight().accept(this);

        StringBuilder restOfMethod = new StringBuilder(handlerName + "(");


        for (VarDeclaration arg : args){
            if (arg.getType().getClass().getSimpleName().equals("OtherType")){
                restOfMethod.append("L").append(((OtherType) arg.getType()).getName()).append(";");
            } else {
                restOfMethod.append(jasminTypes.get(arg.getType().getClass().getSimpleName()));
            }
        }

        restOfMethod.append(")V");


        addCommand("\tinvokevirtual "+ name + "/" + restOfMethod);
        return null;
    }

    @Override
    public String visit(ObserveStatement observeStatement) {

        ArrayList<Identifier> ids = observeStatement.getIds() ;
        String calledType = ids.getFirst().accept(this);
        String type = observeStatement.getArgs().accept(this);

        if (Objects.equals(calledType, "IdType")){
            addCommand("\tinvokevirtual Actor/"+ ids.get(1).getName() + "(" + jasminTypes.get(type) + ")V");
        } else {
            addCommand("\tinvokevirtual "+ calledType + "/" + ids.get(1).getName() + "(" + jasminTypes.get(type) + ")V");
        }


        for (Expression observer : observeStatement.getObservers()){
            String actorType = observer.accept(this);
            String inType = observeStatement.getArgs().accept(this);
            if (Objects.equals(actorType, "IdType")){
                addCommand("\tinvokevirtual Actor/"+ ids.get(1).getName() + "_OBSERVE(" + jasminTypes.get(inType) + ")V");
            } else {
                addCommand("\tinvokevirtual " + actorType + "/" + ids.get(1).getName() + "_OBSERVE("  + jasminTypes.get(inType) + ")V");
            }
        }

        return null;
    }

    private int loopNum = 0 ;

    @Override
    public String visit(ForStatement forStatement) {
        int tempLoopNum = loopNum;
        loopNum++ ;
        SymbolTable tempSymbolTable = currentSymbolTable ;
        currentSymbolTable = forStatement.getSymbolTable() ;

        String itrIndex = "-1" ;
        String itrIndexIndex = "-1";
        String arrayName = ((Identifier) (forStatement.getConditions().getFirst())).getName() ;
        String arraySize = "-1" ;

        if (forStatement.getIterator() != null) {
            itrIndex = forStatement.getIterator().accept(this);
            itrIndexIndex = forStatement.iterator_index.accept(this);
        }

        AssignmentStatement itrAssign = new AssignmentStatement();
        itrAssign.addIdentifier(forStatement.iterator_index.getName());
        itrAssign.setAssigned(new IntValue(0));
        itrAssign.accept(this);

        try {
            arraySize = ((VarDeclarationItem) (currentSymbolTable.getItem("VarDeclaration_"+arrayName))).varDeclaration.getArrayIndex().getIndex() ;
        } catch (ItemNotFound ignored) {}

        addCommand("LOOP"+ tempLoopNum + ":");
        addCommand("\tiload "+ itrIndexIndex);
        addCommand("\tbipush " + arraySize);
        addCommand("\tif_icmpge ENDLOOP" + tempLoopNum );

        forStatement.getConditions().getFirst().accept(this);
        addCommand("\tiload " + itrIndexIndex);
        addCommand("\tinvokevirtual List/getElement(I)Ljava/lang/Object;");
        addCommand("\tastore " + itrIndex);

        for (Statement statement : forStatement.getBody()) {
            statement.accept(this);
        }

        addCommand("\tiinc " + itrIndexIndex + " 1");
        addCommand("\tgoto " + "LOOP" + tempLoopNum);
        addCommand("ENDLOOP" + tempLoopNum + ":");

        currentSymbolTable = tempSymbolTable ;
        return null;
    }


    @Override
    public String visit(IfStatement ifStatement) {
        if (ifStatement.getIfConds() instanceof ExpressionList)
            for (Expression condition : ((ExpressionList) ifStatement.getIfConds()).getExpressionList())
                condition.accept(this);
        else
            ifStatement.getIfConds().accept(this);


        for (Statement statement : ifStatement.getIfBody()) {
            statement.accept(this);
        }

        for (Expression elseIfConds : ifStatement.getElseIfBlocksConds()) {
            elseIfConds.accept(this);

        }

        for (ArrayList<Statement> elseIfBody : ifStatement.getElseIfBlocksBody()) {
            for (Statement statement : elseIfBody) {
                statement.accept(this);
            }
        }

        for (Statement statement : ifStatement.getElseBody()) {
            statement.accept(this);
        }

        return null;
    }


    @Override
    public String visit(WhileStatement whileStatement) {
        if (whileStatement.getConditions() instanceof ExpressionList)
            for (Expression condition : ((ExpressionList) whileStatement.getConditions()).getExpressionList())
                condition.accept(this);
        else
            whileStatement.getConditions().accept(this);

        for (Statement statement : whileStatement.getBody()) {
            statement.accept(this);
        }

        return null;
    }

    @Override
    public String visit(CallExpression callExpression) {

        if (Objects.equals(callExpression.getHandlerName(), "print")){
            if (Objects.equals(callExpression.getExpressions().accept(this), "IntType")){
                addCommand("\tinvokestatic java/lang/String/valueOf(I)Ljava/lang/String;");
            }
            String commands = """
                    \tgetstatic java/lang/System/out Ljava/io/PrintStream;
                    \tswap
                    \tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V""";
            addCommand(commands);
        }else {
            callExpression.getExpressions().accept(this) ;
        }

        return null;
    }


    @Override
    public String visit(BinaryExpression binaryExpression) {
        String Ltype = binaryExpression.getLeftOperand().accept(this);
        String Rtype = binaryExpression.getRightOperand().accept(this);

        if (Objects.equals(Ltype, "IntType") && Objects.equals(Rtype, "StringType")){
            addCommand("\tswap");
            addCommand("\tinvokestatic java/lang/String/valueOf(I)Ljava/lang/String;");
            addCommand("\tswap");
        }

        if (Objects.equals(Ltype, "StringType") && Objects.equals(Rtype, "IntType")){
            addCommand("\tinvokestatic java/lang/String/valueOf(I)Ljava/lang/String;");
        }

        String finalType = null ;

        if(Objects.equals(Ltype, "StringType") || Objects.equals(Rtype, "StringType")) {
            addCommand("\tinvokevirtual java/lang/String/concat(Ljava/lang/String;)Ljava/lang/String;");
            finalType = "StringType" ;
        }

        if (binaryExpression.getBinaryOperator() == BinaryOperator.MULT){
            addCommand("\timul");
        }

        return finalType;
    }

    @Override
    public String visit(Identifier identifier) {
            try {
                SymbolTableItem variableItem = currentSymbolTable.getItem("VarDeclaration_"+identifier.getName()) ;
                VarDeclaration variable = ((VarDeclarationItem) variableItem).varDeclaration ;
                String commands = "\t" ;

                if (variableItem.getLocalIndex() == -2){
                    addCommand("\taload 0");
                    commands +=("getfield " + currentMethod + "/" + identifier.getName() + " " + jasminTypes.get(variable.getType().getClass().getSimpleName()));
                } else if(variable.getType().hasSameType(new IntType()) && ! variable.arrayType){
                    commands += "iload " ;
                    commands += String.valueOf(variableItem.getLocalIndex());
                }else if (variable.getType().getClass().getSimpleName().equals("OtherType") && Objects.equals(((OtherType) variable.getType()).getName(), "ItrType")) {
                    commands += "aload " ;
                    commands += String.valueOf(variableItem.getLocalIndex());
                    commands += "\n" ;
                    commands += "\tcheckcast java/lang/Integer\n\tinvokevirtual java/lang/Integer/intValue()I";
                } else if (variable.arrayType) {
                    commands += "aload " ;
                    commands += String.valueOf(variableItem.getLocalIndex());
                } else {
                    commands += "aload " ;
                    commands += String.valueOf(variableItem.getLocalIndex());
                }

                addCommand(commands);

                if (variable.getType().getClass().getSimpleName().equals("OtherType")){
                    return  ((OtherType) variable.getType()).getName() ;
                }

                return variable.getType().getClass().getSimpleName() ;
            } catch (ItemNotFound ignored) {}

        return null;
    }

    @Override
    public String visit(IntValue intValue) {
        addCommand("\tbipush " + intValue.getIntVal());
        return IntType.class.getSimpleName() ;
    }

    @Override
    public String visit(StringValue stringValue) {
        addCommand("\tldc " + stringValue.getStr());
        return StringType.class.getSimpleName() ;
    }



}
