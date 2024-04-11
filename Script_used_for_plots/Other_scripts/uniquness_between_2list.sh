import sys

def create_unique_ids_file(file1, file2, output_file):
    ids_file1 = set()

    with open(file1, 'r') as f1:
        for line in f1:
            line = line.strip()
            if line != "":
                ids_file1.add(line)

    unique_ids = []

    with open(file2, 'r') as f2:
        for line in f2:
            line = line.strip()
            if line != "" and line not in ids_file1:
                unique_ids.append(line)

    with open(output_file, 'w') as output:
        for unique_id in unique_ids:
            output.write(f'{unique_id}\n')

if __name__ == '__main__':
    file1 = sys.argv[1]
    file2 = sys.argv[2]
    output_file = sys.argv[3]

    create_unique_ids_file(file1, file2, output_file)