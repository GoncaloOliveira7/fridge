import { Table, message } from "antd";
import React, { useState, useEffect } from 'react';

const COLUMNS = [
  {
    title: "ID",
    dataIndex: "id",
    key: "id",
  },
  {
    title: "Name",
    dataIndex: "name",
    key: "name",
  },
  {
    title: "Rate",
    dataIndex: "rate",
    key: "rate",
  },
  {
    title: "People",
    dataIndex: "people_quantity",
    key: "people_quantity",
  },
  {
    title: "Difficulty",
    dataIndex: "difficulty",
    key: "difficulty",
  },
];

export default () => {
  const [recipes, setRecipes] = useState([]);
  const [ingreditens, setIngreditens] = useState('');


  const loadRecipes = () => {
    const url = `api/v1/recipes/index?ingredients=${ingreditens.replaceAll(' ', '%20')}`;
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network error.");
      })
      .then((data) => {
        setRecipes(data);
      })
      .catch((err) => message.error("Error: " + err));
  };

  useEffect(() => {
    loadRecipes()
  }, []);

  return (
    <>
      <input name="filter" value={ingreditens} onChange={e => setIngreditens(e.target.value)} />
      <button onClick={loadRecipes}>Search</button>
      <button onClick={() => setIngreditens('')}>Clear</button>
      <Table className="table-striped-rows" rowKey="id" dataSource={recipes} columns={COLUMNS} pagination={{ pageSize: 100 }} />
    </>
  );
}
