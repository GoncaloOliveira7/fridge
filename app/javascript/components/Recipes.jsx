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
  {
    title: "Priority",
    dataIndex: "priority",
    key: "priority",
  },
];

export default () => {
  const [recipes, setRecipes] = useState([]);
  const [ingreditens, setIngreditens] = useState('');
  const [showAll, setshowAll] = useState(true);
  const handleClick = () => setshowAll(!showAll)

  const loadRecipes = () => {
    const url = `api/v1/recipes/index?showall=&ingredients=${ingreditens.replaceAll(' ', '%20')}&showAll=${showAll}`;
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
      <div>
        <input name="filter" value={ingreditens} onChange={e => setIngreditens(e.target.value)} />
      </div>
      <div style={{ display: 'flex' }}>
        <div>
          <button onClick={loadRecipes}>Search</button>
        </div>
        <div>
          <button onClick={() => setIngreditens('')}>Clear</button>
        </div>
        <div onClick={handleClick} >
          <input checked={showAll} type="checkbox" />
          Show All
        </div>
      </div>
      <Table className="table-striped-rows" rowKey="id" dataSource={recipes} columns={COLUMNS} pagination={{ pageSize: 100 }} />
    </>
  );
}
