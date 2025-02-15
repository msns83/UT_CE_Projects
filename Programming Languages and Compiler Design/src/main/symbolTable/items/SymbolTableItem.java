package main.symbolTable.items;

public abstract class SymbolTableItem {
    protected String name;
    protected int localIndex = -1 ;
    public abstract String getKey();

    public String getName() {
        return name;
    }
    public int getLocalIndex() {return localIndex;}

    public void setLocalIndex(int index) {localIndex = index ;}
    public void setName(String name) {
        this.name = name;
    }
}
