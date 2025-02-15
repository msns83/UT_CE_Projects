.class public Main
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
    .limit stack 128
    .limit locals 128
    new Main
    invokespecial Main/<init>()V
	new List
	dup
	new java/util/ArrayList
	dup
	bipush 3
	aconst_null
	invokestatic java/util/Collections/nCopies(ILjava/lang/Object;)Ljava/util/List;
	invokespecial java/util/ArrayList/<init>(Ljava/util/Collection;)V
	invokespecial List/<init>(Ljava/util/ArrayList;)V
	astore 0
	aload 0
	bipush 0
	bipush 1
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	aload 0
	bipush 1
	bipush 2
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	aload 0
	bipush 2
	bipush 3
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	new List
	dup
	new java/util/ArrayList
	dup
	bipush 3
	aconst_null
	invokestatic java/util/Collections/nCopies(ILjava/lang/Object;)Ljava/util/List;
	invokespecial java/util/ArrayList/<init>(Ljava/util/Collection;)V
	invokespecial List/<init>(Ljava/util/ArrayList;)V
	astore 1
	aload 1
	bipush 0
	bipush 10
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	aload 1
	bipush 1
	bipush 20
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	aload 1
	bipush 2
	bipush 30
	invokestatic java/lang/Integer/valueOf(I)Ljava/lang/Integer;
	invokevirtual List/setElement(ILjava/lang/Object;)V
	bipush 0
	istore 4
LOOP0:
	iload 4
	bipush 3
	if_icmpge ENDLOOP0
	aload 0
	iload 4
	invokevirtual List/getElement(I)Ljava/lang/Object;
	astore 3
	bipush 0
	istore 6
LOOP1:
	iload 6
	bipush 3
	if_icmpge ENDLOOP1
	aload 1
	iload 6
	invokevirtual List/getElement(I)Ljava/lang/Object;
	astore 5
	aload 3
	checkcast java/lang/Integer
	invokevirtual java/lang/Integer/intValue()I
	aload 5
	checkcast java/lang/Integer
	invokevirtual java/lang/Integer/intValue()I
	imul
	istore 2
	iload 2
	invokestatic java/lang/String/valueOf(I)Ljava/lang/String;
	getstatic java/lang/System/out Ljava/io/PrintStream;
	swap
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	iinc 6 1
	goto LOOP1
ENDLOOP1:
	iinc 4 1
	goto LOOP0
ENDLOOP0:
	ldc ""
	getstatic java/lang/System/out Ljava/io/PrintStream;
	swap
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	return
.end method

.method public <init>()V
    .limit stack 128
    .limit locals 128
    aload_0
    invokespecial java/lang/Object/<init>()V
    return
.end method
