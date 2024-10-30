from Bio import SeqIO
import json
import re
import pandas as pd
import os
import sys

def gbk_to_location_data(input_file, output_data):
    with open(output_data, 'w') as data_out:
        data_df=[]
        ALL_df=pd.DataFrame()
        record_id = os.path.basename(input_file).strip(".gbk")
        for record in SeqIO.parse(input_file, 'genbank'):
            for feature in record.features:
                if feature.type == 'CDS':
                    start = feature.location.start.position + 1  # Convert to 1-based position
                    end = feature.location.end.position
                    strand = '+' if feature.strand >= 0 else '-'
                    # Get gene_id attribute
                    gene_kind = feature.qualifiers.get('gene_kind', [''])[0]
                    if gene_kind == '':
                        gene_kind='other'
                    gene_id = feature.qualifiers.get('gene_id', [''])[0]
                    if gene_id == '':
                        gene_id=feature.qualifiers.get('locus_tag', [''])[0]
                    data_df.append([record_id, gene_id, start, end, strand, gene_kind])
            ALL_df =  ALL_df._append(data_df)
        ALL_data=pd.DataFrame(data_df, columns = ["BGC_ID","Gene","Start", "End", "Strand","Function"])
        #return pd.DataFrame(data_df, columns = ["BGC_ID","Gene","Start", "End", "Strand","Function"])
    ALL_data.to_csv(output_data, sep=',', index=False, header=True)


def json_to_location_data(input_file):
    #with open(output_data, 'w') as data_out:
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
                area_data = ID_df[(ID_df['Start'] >= area_start) & (ID_df['End'] <= area_end)]
                area_data.insert(0, "BGC_ID", areas_ID)
                Areas_df = Areas_df._append(area_data)
        ALL_df =  ALL_df._append(Areas_df)
        return ALL_df
    #ALL_df.to_csv(output_data, sep=',', index=False, header=True)


# def main(input_files, output_data):
#     all_data=[]
#     print(input_files)
#     for input_file in input_files:
#         print(input_file)
#         if input_file.endswith(".json"):
#             data = json_to_location_data(input_file)
#         else:
#             data = gbk_to_location_data(input_file)
#         all_data.append(data)
#     all_data_df = pd.concat(all_data, ignore_index=True)
#     all_data_df.to_csv(output_data, sep=",", index=False, header=True)
# Example usage
#input_files = ['/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/ragtag.scaffold.json']
# input_files=['/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/CP126066.1_RagTag.region001.gbk',
#              '/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/CP126066.1_RagTag.region002.gbk',
#             '/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/CP126066.1_RagTag.region039.gbk',
#             '/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/CP126066.1_RagTag.region009.gbk',
#             ]
# output_data = '/Volumes/homes/Zhu_Wenbo/RNA_Seq/Refsequence/pip-m1/CP126066.1_Region_ALLL111.csv'

input_files = sys.argv[1]
output_data = sys.argv[2]

gbk_to_location_data(input_files, output_data)