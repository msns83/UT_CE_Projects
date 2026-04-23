package com.example.demo.features.product.service;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;

import com.example.demo.features.product.model.Product;
import com.example.demo.features.product.repository.ProductRepository;

@ExtendWith(MockitoExtension.class)
class ProductServicesRepositoryTest {

    @Mock ProductRepository productRepository;
    @InjectMocks ProductServices productServices;

    private Product product(int id, String name) {
        Product p = new Product();
        p.setPid(id);
        p.setPname(name);
        return p;
    }

    @Test
    @DisplayName("addProduct delegates to repository.save")
    void addProduct_calls_save() {
        Product p = product(0, "Milk");
        productServices.addProduct(p);
        verify(productRepository).save(p);
    }

    @Test
    @DisplayName("getAllProducts delegates to repository.findAll and returns list")
    void getAllProducts_calls_findAll() {
        Product p1 = product(1, "Sugar");
        Product p2 = product(2, "Salt");
        when(productRepository.findAll()).thenReturn(List.of(p1, p2));

        List<Product> out = productServices.getAllProducts();

        verify(productRepository).findAll();
        Assertions.assertEquals(2, out.size());
        Assertions.assertEquals("Sugar", out.get(0).getPname());
    }

    @Test
    @DisplayName("getProduct delegates to repository.findById")
    void getProduct_calls_findById() {
        Product p = product(10, "Rice");
        when(productRepository.findById(10)).thenReturn(Optional.of(p));

        Product out = productServices.getProduct(10);

        verify(productRepository).findById(10);
        Assertions.assertSame(p, out);
    }

    @Test
    @DisplayName("updateproduct sets pid and saves when existing present")
    void updateproduct_sets_id_and_saves() {
        Product incoming = product(0, "Updated");
        Product existing = product(5, "Old");
        when(productRepository.findById(5)).thenReturn(Optional.of(existing));

        productServices.updateproduct(incoming, 5);

        Assertions.assertEquals(5, incoming.getPid());
        InOrder inOrder = inOrder(productRepository);
        inOrder.verify(productRepository).findById(5);
        inOrder.verify(productRepository).save(incoming);
    }

    @Test
    @DisplayName("deleteProduct delegates to repository.deleteById")
    void deleteProduct_calls_deleteById() {
        productServices.deleteProduct(7);
        verify(productRepository).deleteById(7);
    }

    @Test
    @DisplayName("getProductByName returns product when found")
    void getProductByName_found() {
        Product p = product(33, "Cheese");
        when(productRepository.findByPname("Cheese")).thenReturn(p);

        Product out = productServices.getProductByName("Cheese");

        verify(productRepository).findByPname("Cheese");
        Assertions.assertSame(p, out);
    }

    @Test
    @DisplayName("getProductByName returns null when not found")
    void getProductByName_not_found() {
        when(productRepository.findByPname("Unknown")).thenReturn(null);

        Product out = productServices.getProductByName("Unknown");

        verify(productRepository).findByPname("Unknown");
        Assertions.assertNull(out);
    }
}