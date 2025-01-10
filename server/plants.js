document.getElementById('new-plant-btn').addEventListener('click', () => {
    console.log('New Plant button clicked!');
    const name = document.getElementById('new-plant-name').value;
    const description = document.getElementById('new-plant-description').value;

    fetch('/plants', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({name, description})
    })
    .then(response => {
        if (response.ok) {
            console.log('Plant added successfully');
        } else {
            console.error('Failed to add plant');
        }
    });


});