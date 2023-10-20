async function getUserMediaPermission(constraints) {
    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints)
        if (stream) {
            stream.tracks.forEach(track => track.stop())
            return true
        }
        return false
    } catch (error) {
        return false
    }
}

const permissionGranted = getUserMediaPermission({audio: true})
if (!permissionGranted) console.log('Hey! to use this you must grant permission!')