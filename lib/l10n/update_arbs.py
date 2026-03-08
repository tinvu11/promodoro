import json
import os
import glob
import urllib.request
import urllib.parse
import time

def translate(text, target_lang):
    if target_lang == 'zh': target_lang = 'zh-CN'
    url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={target_lang}&dt=t&q={urllib.parse.quote(text)}"
    req = urllib.request.Request(url, headers={'User-Agent': "Mozilla/5.0"})
    try:
        response = urllib.request.urlopen(req)
        res_data = response.read().decode('utf-8')
        res_json = json.loads(res_data)
        return "".join([sent[0] for sent in res_json[0]])
    except Exception as e:
        print(f"Error translating '{text}' to '{target_lang}': {e}")
        return text

en_file = 'd:/Flutter/Projects/promodoro/lib/l10n/app_en.arb'
with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

# Metadata to copy directly
metadata_keys = ['@repeatTimes', '@minutes', '@hoursAndMinutes', '@hoursOnly', '@minutesOnly', '@totalLabel']
text_keys = ['noData', 'noInternet', 'tryAgainConnect', 'tryAgain']

for file in glob.glob('d:/Flutter/Projects/promodoro/lib/l10n/*.arb'):
    if file == en_file or file.endswith('app_vi.arb'): continue
    
    lang_code = os.path.basename(file).replace('app_', '').replace('.arb', '')
    with open(file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    changed = False
    
    # Copy metadata keys directly from en
    for mk in metadata_keys:
        if mk in en_data and mk not in data:
            data[mk] = en_data[mk]
            changed = True
            
    # Translate text keys
    for tk in text_keys:
        if tk in en_data and tk not in data:
            # hoursOnly and minutesOnly have placeholders like {hours}h, we can translate the 'h' or 'm' or keep as is.
            # let's just translate them
            translated = translate(en_data[tk], lang_code)
            data[tk] = translated
            changed = True
            time.sleep(1) # avoid rate limit
            
    if changed:
        with open(file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            # Flutter expects format like original, but dump works well. 
        print(f"Updated {file}")

print("Done updating arb files.")
