setTimeout(function() {
    var noticeElement = document.getElementById('notice');
    if (noticeElement) {
      noticeElement.style.opacity = '0';
      setTimeout(function() {
        noticeElement.style.display = 'none';
      }, 500);
    }
  }, 3000);


document.addEventListener("DOMContentLoaded", function () {
    const companyModal = document.getElementById("companyModal");
    const closeModalButton = document.getElementById("closeModal");

    const deleteModal = document.getElementById("deleteModal");
    const cancelDeleteButton = document.getElementById("cancelDelete");
    const confirmDeleteButton = document.getElementById("confirmDelete");
    let entityIdToDelete = null;
    let entityTypeToDelete = null;

    function openModal() {
      companyModal.classList.add("show"); // Add the 'show' class to trigger the animation
    }
  
    // Function to close the modal
    function closeModal() {
      companyModal.classList.remove("show");
      setTimeout(() => {
        document.getElementById("modalContent").innerHTML = "";
      }, 400);
    }

    companyModal.addEventListener("click", function (event) {
      // Check if the click target is the modal itself (background overlay)
      if (event.target === companyModal || event.target.classList.contains("overlay")) {
        closeModal();
      }
    });

    closeModalButton.addEventListener("click", closeModal);

  // Handle row clicks to load employee details
  document.querySelectorAll("tr[data-id]").forEach((row) => {
    row.addEventListener("click", function (event) {
      if (event.target.closest(".action-buttons")) return;

      const entityId = this.getAttribute("data-id");
      const entityType = this.getAttribute("data-type");
      fetch(`/chitoge/${entityType}s/${entityId}.json`)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          const modalContent = document.getElementById("modalContent");
          modalContent.innerHTML = `
            <p class="mb-2"><strong class="text-gray-700">Name:</strong> ${data.name}</p>
            <p class="mb-2"><strong class="text-gray-700">Code:</strong> ${data.code}</p>
          `;
          openModal();
        })
        .catch((error) => {
          console.error("Error fetching company details:", error);
          alert("Failed to load company details. Please try again.");
        });
    });
  });

  
    // Function to open the delete modal
    function openDeleteModal(entityId, entityType) {
      entityIdToDelete = entityId; // Store the entity ID
    entityTypeToDelete = entityType; // Store the entity type
    deleteModal.classList.remove("hidden");
    }
  
    // Function to close the modal
    function closeDeleteModal() {
      deleteModal.classList.add("hidden");
      entityIdToDelete = null;
      entityTypeToDelete = null;
    }
  
    // Event listener for all delete buttons
    document.querySelectorAll(".delete-button").forEach((button) => {
      button.addEventListener("click", function () {
        const entityId = this.getAttribute("data-id");
        const entityType = this.getAttribute("data-type");
        openDeleteModal(entityId, entityType);
      });
    });
  
    cancelDeleteButton.addEventListener("click", closeDeleteModal);
  
    confirmDeleteButton.addEventListener("click", function (event) {
      event.preventDefault();
      console.log(`Entity ID to delete: ${entityIdToDelete}, Entity type: ${entityTypeToDelete}`);
    
      if (entityIdToDelete && entityTypeToDelete) {
        // Send a DELETE request to the server with the employee's ID
        fetch(`/chitoge/${entityTypeToDelete}/${entityIdToDelete}`, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content, 
          },
        })
          .then((response) => {
            if (response.ok) {
              return response.json();
            } else {
              throw new Error(`Failed to delete the ${entityTypeToDelete}`);
            }
            })
            .then((data) => {
            console.log(data.message);
            window.location.reload();

            const entityRow = document.querySelector(`tr[data-id="${entityIdToDelete}"][data-type="${entityTypeToDelete}"]`);
            if (entityRow) {
              entityRow.remove();
            }
            closeDeleteModal(); 
            })
            .catch((error) => {
            console.error("Error:", error);
          });
      }
    });

  });