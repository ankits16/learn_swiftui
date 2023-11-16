import React from 'react';
import Select from 'react-select';

const options = [
  { value: 'chocolate', label: 'Chocolate' },
  { value: 'strawberry', label: 'Strawberry' },
  { value: 'vanilla', label: 'Vanilla' },
  { value: 'mango', label: 'Mango' },
  { value: 'banana', label: 'Banana' },
  { value: 'pineapple', label: 'Pineapple' },
  { value: 'blueberry', label: 'Blueberry' },
  { value: 'kiwi', label: 'Kiwi' },
  { value: 'grape', label: 'Grape' },
  // ... you can add as many as you need
];

function MultiSelectWithSearch() {
  const [selectedOptions, setSelectedOptions] = React.useState([]);

  return (
    <Select
      isMulti
      name="fruits"
      options={options}
      className="basic-multi-select"
      classNamePrefix="select"
      onChange={setSelectedOptions}
      value={selectedOptions}
    />
  );
}

export default MultiSelectWithSearch;
