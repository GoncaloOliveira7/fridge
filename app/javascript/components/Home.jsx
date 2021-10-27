import React from "react";
import { Layout } from "antd";
import Recipes from "./Recipes";

const { Content, Footer } = Layout;

export default () => (
  <Layout className="layout">
    <Content style={{ padding: "0 50px" }}>
      <div className="site-layout-content" style={{ margin: "100px auto" }}>
        <h1>Hello World</h1>
        <Recipes />
      </div>
    </Content>
  </Layout>
);
