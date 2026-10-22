from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]

def ob(required, props, extra=False):return {'type':'object','required':required,'properties':props,'additionalProperties':extra}
def s():return {'type':'string','minLength':1}
def integer():return {'type':'integer','minimum':1}
review={'type':'string','enum':['draft','in_review','approved','retired']}
file=ob(['path','bytes','sha256'],{'path':s(),'bytes':{'type':'integer','minimum':0},'sha256':{'type':'string','pattern':'^[a-fA-F0-9]{64}$'}})
step=ob(['order','instruction','framePath'],{'order':integer(),'instruction':s(),'framePath':s()})
exercise=ob(['id','version','locale','title','defaultDurationSeconds','position','intensity','tags','reviewStatus','demoOnly','safetyNotes','steps','posterMediaId','mediaAssetIds'],{'id':{'type':'string','pattern':'^E[0-9]{2,}$'},'version':integer(),'locale':s(),'title':s(),'defaultDurationSeconds':integer(),'position':{'enum':['seated','standing','mixed']},'intensity':{'enum':['gentle','easy','moderate']},'tags':{'type':'array','items':s()},'reviewStatus':review,'demoOnly':{'type':'boolean'},'safetyNotes':{'type':'array','minItems':1,'items':s()},'steps':{'type':'array','minItems':1,'items':step},'posterMediaId':s(),'mediaAssetIds':{'type':'array','minItems':1,'items':s()}})
rstep=ob(['order','exerciseId','exerciseVersion','durationSeconds','mediaVariant'],{'order':integer(),'exerciseId':s(),'exerciseVersion':integer(),'durationSeconds':integer(),'mediaVariant':{'enum':['storyboard','video','rive']}})
routine=ob(['id','version','locale','title','description','tags','reviewStatus','demoOnly','totalDurationSeconds','steps'],{'id':{'type':'string','pattern':'^R[0-9]{2,}$'},'version':integer(),'locale':s(),'title':s(),'description':s(),'tags':{'type':'array','items':s()},'reviewStatus':review,'demoOnly':{'type':'boolean'},'totalDurationSeconds':integer(),'steps':{'type':'array','minItems':1,'items':rstep}})
media=ob(['id','version','kind','locale','files','reviewStatus','demoOnly','aiGenerated','rights','accessibilityDescription'],{'id':s(),'version':integer(),'kind':{'enum':['storyboard','video','rive','audio','poster']},'locale':s(),'files':{'type':'array','minItems':1,'items':file},'reviewStatus':review,'demoOnly':{'type':'boolean'},'aiGenerated':{'type':'boolean'},'rights':s(),'accessibilityDescription':s()})
manifest=ob(['schemaVersion','catalogId','catalogVersion','locale','status','demoOnly','contentManagement','exercises','routines','mediaAssets'],{'schemaVersion':{'const':1},'catalogId':s(),'catalogVersion':s(),'locale':s(),'status':{'enum':['draft','published','retired']},'demoOnly':{'type':'boolean'},'contentManagement':ob(['source','futureBackend','syncEnabled'],{'source':s(),'futureBackend':s(),'syncEnabled':{'type':'boolean'}}),'exercises':{'type':'array','minItems':1,'items':exercise},'routines':{'type':'array','minItems':1,'items':routine},'mediaAssets':{'type':'array','minItems':1,'items':media}})
manifest['$schema']='https://json-schema.org/draft/2020-12/schema';manifest['title']='An Nhien content catalog schema v1'
p=ROOT/'catalog/catalog.schema.v1.json';p.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print('wrote',p)
