from Bio import SeqIO
import json
import re
import pandas as pd
import os
import sys

input_file = sys.argv[1]
output_data = sys.argv[2]

def json_to_location_data(input_file, output_data):
    with open(output_data, 'w') as data_out:
        file = open(input_file, encoding = 'utf-8')
        lines = [line.strip('\n') for line in file.readlines()]
        file.close()
        string = "".join(lines)
        root = json.loads(string)
        records = root['records']
        i=0
        ALL_df = pd.DataFrame()
        Areas_df = pd.DataFrame()
        for record in records:
            i=i+1
            record_id = record["id"]
            features = record["features"]
            areas = record["areas"]
            modules = record['modules']
            j=0
            ID_data=[]
            for feature in features:
                if feature['type'] == 'CDS':
                    #gene id
                    if 'gene_id' in feature['qualifiers']:
                        gene_id = feature['qualifiers']['gene_id'][0]
                    else :
                        gene_id = feature['qualifiers']['locus_tag'][0]
                    #gene kind
                    if 'gene_kind' in feature['qualifiers']:
                        gene_kind = feature['qualifiers']['gene_kind'][0]
                    else :
                        gene_kind = 'other'
                    #location
                    if 'join' in feature['location']:
                        ID_Start = int(min(re.findall("\d+\.?\d*", feature['location'])))
                        ID_End = int(max(re.findall("\d+\.?\d*", feature['location'])))
                        Strand=feature['location'][-3]
                    else:
                        ID_Start = int(feature['location'].strip("(+)(-)").strip('[]').split(":")[0].strip('<').strip('>'))
                        ID_End = int(feature['location'].strip("(+)(-)").strip('[]').split(":")[1].strip('<').strip('>'))
                        Strand=feature['location'][-2]
                    ID_data.append([gene_id, ID_Start+1, ID_End, Strand, gene_kind])
            ID_df = pd.DataFrame(ID_data, columns = ["Gene","Start", "End", "Strand","Function"])
            #print(ID_df)

            for area in areas:
                j=j+1
                area_data=[]
                areas_ID =  f"{record_id}_{i}.{j}"
                area_start = area['start']
                area_end = area['end']
                area_data = ID_df[(ID_df['Start'] > area_start) & (ID_df['End'] < area_end)]
                area_data.insert(0, "BGC_ID", areas_ID)
                Areas_df = Areas_df._append(area_data)
        ALL_df =  ALL_df._append(Areas_df)
    ALL_df.to_csv(output_data, sep=',', index=False, header=True)


def main(input_file, output_data):
    json_to_location_data(input_file, output_data)

# Example usage
#input_file = '/Volumes/homes/Deng_Qisen/PAC_G10_RNA_Seq/Reference/PACG10-Assemble-full/PACG10-Assemble-full.json'
#output_data = '/Volumes/Wang_Lab/Wang_Lab/Lab_Database/BGC_Cool/www/sh_file/PACG10-Assemble-full.genekind.data_merge.csv'

main(input_file, output_data)