import React from 'react';
import AsyncSelect from 'react-select/async';
import axios from 'axios';

function AsyncSelectDropdown() {
    const [selectedOptions, setSelectedOptions] = React.useState([]);

    const loadOptions = async (inputValue, callback) => {
      if (!inputValue) return callback([]);
  
      try {
        const response = await axios.get(`https://jsonplaceholder.typicode.com/posts`);
        const posts = response.data;
  
        // Filter posts based on the user's query against the title
        const filteredPosts = posts.filter(post => 
          post.title.toLowerCase().includes(inputValue.toLowerCase())
        );
  
        const options = filteredPosts.map(post => ({
          value: post.id,
          label: post.title,
        }));
  
        callback(options);
      } catch (error) {
        console.error('Error fetching data:', error);
        callback([]);
      }
    };

  return (
    <AsyncSelect
      isMulti
      cacheOptions
      loadOptions={loadOptions}
      defaultOptions
      onChange={setSelectedOptions}
      value={selectedOptions}
    />
  );
}

export default AsyncSelectDropdown;


