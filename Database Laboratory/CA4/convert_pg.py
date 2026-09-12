import re

db_path = 'FilimoDatabase.sql'
db_out = 'FilimoDatabasePG.sql'

with open(db_path, 'r', encoding='utf-8') as f:
    sql = f.read()

# Remove backticks and inline pragmas
sql = sql.replace('`', '')
sql = re.sub(r'/\*!.*?\*/;?', '', sql)

# Remove CREATE DATABASE and USE
sql = re.sub(r'(?i)CREATE DATABASE.*?;?', '', sql)
sql = re.sub(r'(?i)USE\s+\w+;', '', sql)

# Remove LOCK/UNLOCK TABLES
sql = re.sub(r'(?i)\bLOCK TABLES[^;]*;', '', sql)
sql = re.sub(r'(?i)\bUNLOCK TABLES[^;]*;', '', sql)

# Fix engine/charset
sql = re.sub(r'(?i)\)\s*ENGINE=[a-zA-Z0-9_]+\s*(DEFAULT\s*CHARSET=[a-zA-Z0-9_]+)?\s*(COLLATE=[a-zA-Z0-9_]+)?\s*;\s*', ');\n', sql)

# Fix datatypes
sql = re.sub(r'(?i)\btinyint(?:\(\d+\))?', 'smallint', sql)
sql = re.sub(r'(?i)\bint\(\d+\)', 'int', sql)

# Process tables
tables = re.split(r'(?i)CREATE TABLE', sql)
out_sql = tables[0]

alter_statements = []

for part in tables[1:]:
    match = re.search(r'^\s*(\w+)\s*\(', part)
    if not match:
        out_sql += 'CREATE TABLE' + part
        continue
        
    table_name = match.group(1)
    
    # Extract the table definition block inside ( ... );
    # We find everything up to ");"
    end_idx = part.find(');')
    if end_idx == -1:
        out_sql += 'CREATE TABLE' + part
        continue
        
    def_block = part[part.find('(')+1 : end_idx]
    after_block = part[end_idx+2:]
    
    lines = def_block.split('\n')
    new_lines = []
    
    for line in lines:
        line_stripped = line.strip()
        if not line_stripped:
            continue
            
        # Ensure we don't accidentally match parts of column names
        if line_stripped.upper().startswith('UNIQUE KEY'):
            m = re.search(r'(?i)UNIQUE KEY\s+\w+\s*\((.*?)\)', line)
            if m:
                new_line = re.sub(r'(?i)UNIQUE KEY\s+\w+\s*\((.*?)\)', r'UNIQUE (\1)', line)
                new_lines.append(new_line)
        elif line_stripped.upper().startswith('KEY'):
            continue
        elif line_stripped.upper().startswith('CONSTRAINT'):
            c = re.search(r'(?i)(CONSTRAINT\s+\w+\s+FOREIGN KEY.*)', line)
            if c:
                c_str = c.group(1).rstrip(',')
                alter_statements.append(f"ALTER TABLE {table_name} ADD {c_str};")
            continue
        else:
            new_lines.append(line)
            
    # Clean up trailing comma on the very last column/constraint line
    if new_lines:
        new_lines[-1] = new_lines[-1].rstrip().rstrip(',')
        
    cleaned_def = '\n'.join(new_lines)
    
    # Reassemble
    out_sql += f'CREATE TABLE {table_name} (\n{cleaned_def}\n);\n{after_block}'

out_sql += "\n\n-- Foreign Keys added after table creation\n"
out_sql += "\n".join(alter_statements)

with open(db_out, 'w', encoding='utf-8') as f:
    f.write(out_sql)

print("Conversion script finished.")
