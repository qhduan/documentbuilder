const express = require('express')
const bodyParser = require('body-parser')
const child_process = require("child_process")
const fs = require('fs')
const path = require('path')

const app = express()
const jsonParser = bodyParser.json()

const builderPath = '/opt/onlyoffice/documentbuilder/docbuilder'

function saveFile(docx, script) {
    return new Promise((resolve, reject) => {
        fs.mkdtemp('docbuilder-', (err, directory) => {
            if (err) return reject(err)
            const docPath = path.resolve(path.join(directory, 'input.docx'))
            const scriptPath = path.resolve(path.join(directory, 's.docbuilder'))

            console.log('saving docx to', docPath)
            console.log('saving script to', scriptPath)

            fs.writeFile(docPath, Buffer.from(docx, 'base64'), "binary", err => {
                if (err) return reject(err)
                fs.writeFile(scriptPath, Buffer.from(script, 'base64'), "binary", err => {
                    if (err) return reject(err)
                    const cwd = path.resolve(directory)
                    console.log('running docbuilder', cwd)
                    child_process.execFile(
                        builderPath,
                        [scriptPath],
                        { cwd: cwd },
                        (err, stdout) => {
                            if (err) return reject(err)
                            console.log('removing tmpdir', cwd)
                            fs.rmdir(cwd, { recursive: true }, (err) => {
                                if (err) return reject(err)
                                const start = stdout.indexOf('===START===')
                                const end = stdout.indexOf('===END===')
                                if (start >= 0 && end >= 0) {
                                    const jsonStr = stdout.substring(start + 11, end)
                                    resolve(JSON.parse(jsonStr))
                                } else {
                                    reject(new Error('Invalid parse output'))
                                }
                            })
                        }
                    )
                })
            })

            
            // fs.unlink
        })
    })
}

/**
 * curl -XPOST localhost:3000/api/docbuilder -H 'Content-Type: application/json' -d '{"1": 2}'
 */
app.post('/api/docbuilder', jsonParser, async (req, res) => {
    try {
        const ret = await saveFile(req.body.docx, req.body.script)
        res.send({
            'data': ret,
            'ok': true,
        })
    } catch (e) {
        res.send({
            'error': e.toString(),
            'ok': false,
        })
    }
    res.end()
})

app.listen(3000)
