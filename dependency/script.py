'''
mvn org.apache.maven.plugins:maven-dependency-plugin:2.4:tree -DoutputFile=dependency.txt
mvn org.apache.maven.plugins:maven-dependency-plugin:2.4:tree -DoutputType=dot -DoutputFile=dependency.dot
'''

modules = ["twc-search-rpm",
           "twc-uhe-ingest-rpm",
           "twc-ssr-ingest-rpm",
           "twc-pps-ingest-rpm"]

f = open('dependency.dot', 'r')
lines = f.readlines()
f.close()

lines = lines[1:-1] #removes first and last lines

keys = []
vals = []

for line in lines:
    p = line.replace(';', '').split('->')
    key = p[0].strip().replace('\"', '').replace(':compile', '')
    keys.append(key)
    val = p[1].strip().replace('\"', '').replace(':compile', '')
    vals.append(val)

excludes = ["com.nds.cab.infra:cabConfiguration",
            "com.nds.cab.infra:cabLogging",
            "com.nds.cab.infra:cabMonitoring",
            "com.nds.cab.infra:cabCommunication"]

def excluded(item):
    for e in excludes:
        if item.startswith(e):
            return True
    return False

def findDeps(keys, vals, result):
    if not result:
        result.append(vals[0]) #initialises result list with a first item
    for i in range(0, len(keys)):
        if keys[i] in result and not excluded(vals[i]):
            result.append(vals[i])
    return result

result = findDeps(keys, vals, [])
# removes redundant dependencies to project's modules
result = [ item for item in result if not item.startswith("com.nds.cab.twowaycat") ]
result.sort()

for item in result:
    print item

print len(result)
