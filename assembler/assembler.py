entrada = 'entrada.txt'
saida = 'assembly.txt'

labels = {}

def converteArroba(line):
  items = line.replace("\n", "").split('@')
  addr = bin(int(items[-1]))[2:].zfill(9)
  return addr

def converteCifrao(line):
  items = line.replace("\n", "").split('$')
  num = bin(int(items[-1]))[2:].zfill(9)
  return num

def converteMnemonico(line):
  return line.replace("\n", "").split(' ')[0]

def converteParaLabel(line):
  if '@' in line:
    l = converteMnemonico(line) + ' & \"' + converteArroba(line) + '\";'
  elif '$' in line:
    l = converteMnemonico(line) + ' & \"' + converteCifrao(line) + '\";'
  elif '%' in line:
    l = converteMnemonico(line) + ' & \"' + line.split('%')[-1].replace("\n", "") + '\";'
  else:
    l = line

  return l 

def pegaPosicaoTmp(line):
  return line.split('(')[0][:1]

def converteLabel(line):
  return line.split('%')[-1].replace("\n", "")

with open(entrada, "r") as f:
  lines = f.readlines()

cont_labels = 0
for index, line in enumerate(lines):
  line = line.replace("\n", "")
  if ':' in line:
    labels[line.split(':')[0]] = {"pos": index-cont_labels}
    cont_labels+=1

for index, line in enumerate(lines):
  line = line.replace("\n", "")
  if 'JSR' in line:
    label = line.split('%')[-1]
    labels[label]["type"] = "JSR"
  else:
    if line.startswith('J'):
      label = line.split('%')[-1]
      type = line.split('%')[0]
      labels[label]["type"] = type.replace(" ", "")

with open(saida, "w+") as f:

  cont = 0
  for line in lines:
    if not ':' in line:
      if '@' in line:
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"' + converteArroba(line) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif '$' in line:
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"' + converteCifrao(line) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif '%' in line:
        label = converteLabel(line)
        tmp = int(labels[label]["pos"])
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"' + bin(tmp)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif line.replace("\n", "").replace(" ", "") == "RET":
        t = 'tmp(' + str(cont) + ') := ' + line.replace("\n", "") + ' & \"' + bin(0)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif line.replace("\n", "") == "NOP":
        t = 'tmp(' + str(cont) + ') := ' + line.replace("\n", "") + ' & \"' + bin(0)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      else:
        t = line
        cont+=1

      f.write(t)
    else:
      label = line.split(':')[0]
      type = labels[label]["type"]
      if type == "JSR":
        t = '-- ' + label + '\n'
        f.write(t)